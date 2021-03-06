//
//  SecondViewController.swift
//  ChOrganizeApp
//
//  Created by Hana on 11/4/17.
//  Copyright © 2017 Pusheen Code. All rights reserved.
//

import UIKit

class GroupViewController: UITableViewController {

    var groups = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
        print ("in GroupViewController")
        
        fetchGroups()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "reloadGroupTableView"), object: nil)
    }
    
    func loadList(){
        groups = [Group]()
        fetchGroups()
        //load data here
        self.tableView.reloadData()
    }
    
    func fetchGroups(){
        // Get Email
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email")!
        
        // Get Groups
        getGroups(email: email) {
            (groupslist: [Group]) in
            self.groups = groupslist
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTableViewCell", for: indexPath) as? GroupTableViewCell
        let group = groups[indexPath.row]
        
        cell!.nameLabel.text = group.name
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "groupToGroupName" {
            if let destVC = segue.destination as? GroupSplitViewController {
                let groupToPass = groups[tableView.indexPathForSelectedRow!.row]
                destVC.groupName = groupToPass.name
                destVC.groupID = groupToPass.id
            }
        }
        if segue.identifier == "groupsToProfile" {
            if let destVC = segue.destination as? ProfileViewController {
                // Get email
                let defaults = UserDefaults.standard
                let email: String = defaults.string(forKey: "email")!
                // Get user details
                getUser(email: email) {
                    (user: User) in
                    destVC.firstNameLabel.text = user.firstName
                    destVC.lastNameLabel.text = user.lastName
                    destVC.emailLabel.text = email
                }
            }
        }
    }
    
}

