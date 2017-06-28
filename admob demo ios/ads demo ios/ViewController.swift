//
//  ViewController.swift
//  ads demo ios
//
//  Created by Solomon Li on 04/01/2017.
//  Copyright © 2017 Unity Technologies. All rights reserved.
//

import UIKit
import AdSupport
import GoogleMobileAds

class ViewController: GameViewController {

    // view outlets
    @IBOutlet weak var messageView: UITextView!
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var viewAdsButton: UIButton!
    @IBOutlet weak var gameIdLabel: UILabel!
    @IBOutlet weak var placementIdLabel: UILabel!
    
    var coins = 0
    let rewardCoinAmount = 12
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameIdLabel.text = "not apply"
        placementIdLabel.text = "not apply"
        self.viewAdsButton.titleLabel?.textAlignment = NSTextAlignment.center
        let idfaString = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        print("idfa = " + idfaString)
//        [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func rewardPlayer() {
        coins += rewardCoinAmount
        self.coinsLabel.text = String(coins)
    }
    
    func setButtonState(enabled: Bool) {
        self.viewAdsButton.isEnabled = enabled
        self.viewAdsButton.isUserInteractionEnabled = enabled
        let text = enabled ? "Get free coins" : "Free coins not available yet"
        self.viewAdsButton.setTitle(text, for: UIControlState.normal)
    }
    
    @IBAction func viewAdsButtonTapped(_ sender: Any) {
        print("[ViewController] viewAdsButtonTapped")
        if(GADRewardBasedVideoAd .sharedInstance().isReady) {
            GADRewardBasedVideoAd.sharedInstance().present(fromRootViewController: self)
        }
    }
}

extension ViewController: GADRewardBasedVideoAdDelegate {
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didRewardUserWith reward: GADAdReward) {
        rewardPlayer()
        self.messageView.text = "video completed"
    }
    
    func rewardBasedVideoAdDidReceive(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        setButtonState(enabled: GADRewardBasedVideoAd.sharedInstance().isReady)
        print("[UnityAdsDelegate] rewardBasedVideoAdDidReceive")
    }
    
    func rewardBasedVideoAdDidOpen(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("[UnityAdsDelegate] rewardBasedVideoAdDidOpen")
        setButtonState(enabled: false)
    }
    
    func rewardBasedVideoAdDidStartPlaying(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("[UnityAdsDelegate] rewardBasedVideoAdDidStartPlaying")
        let req = GADRequest()
        GADRewardBasedVideoAd.sharedInstance().load(req, withAdUnitID: Values.adUnityId)
    }
    
    func rewardBasedVideoAdDidClose(_ rewardBasedVideoAd: GADRewardBasedVideoAd) {
        print("[UnityAdsDelegate] rewardBasedVideoAdDidClose")
    }
    
    func rewardBasedVideoAd(_ rewardBasedVideoAd: GADRewardBasedVideoAd, didFailToLoadWithError error: Error) {
        print("[UnityAdsDelegate] didFailToLoadWithError, errorMessage=" + error.localizedDescription)
    }
}
