import Foundation

@objc(StandaloneVideoPlayer)
class StandaloneVideoPlayer: RCTEventEmitter {

    override func supportedEvents() -> [String]! {
        return ["PlayerStatusChanged", "PlayerProgressChanged"]
    }

    
    //
    
    @objc(newInstance)
    func newInstance() -> Void {
        _=PlayerVideo.newInstance()
    }
    
    //
  
    @objc(setVolume:volume:)
    func setVolume(instance: Int, volume: Float) {
      guard instance >= 0 && instance < PlayerVideo.instances.count else { return }
      
      PlayerVideo.instances[instance].setVolume(volume: volume)
    }

    //

    @objc(load:withUrl:withHls:withLoop:withSilent:)
    func load(instance: Int, withUrl url: String, withHls hls: Bool, withLoop loop: Bool, withSilent silent: Bool) -> Void {
        guard instance >= 0 && instance < PlayerVideo.instances.count else { return }
        
        let player = PlayerVideo.instances[instance]
        player.shouldRecordingLoop = loop
        
        player.statusChanged = { status in
            self.sendEvent(withName: "PlayerStatusChanged", body: ["status" : status.rawValue, "instance": instance])
        }
        
        player.progressChanged = { progress, duration in
            self.sendEvent(withName: "PlayerProgressChanged", body: ["progress" : progress, "duration" : duration, "instance": instance])
        }
        
        player.load(url: url)
    }
    
    //
    @objc(seek:toPosition:)
    func seek(instance: Int, toPosition position: Double) {
        guard instance >= 0 && instance < PlayerVideo.instances.count else { return }
        
        PlayerVideo.instances[instance].seekTo(position: position)
    }
    
    //
    
    @objc(seekForward:withTime:)
    func seekForward(instance: Int, withTime time: Double) {
        guard instance >= 0 && instance < PlayerVideo.instances.count else { return }
        
        PlayerVideo.instances[instance].seekForward(time: time)
    }
    
    //
    
    @objc(seekRewind:withTime:)
    func seekRewind(instance: Int, withTime time: Double) {
        guard instance >= 0 && instance < PlayerVideo.instances.count else { return }
        
        PlayerVideo.instances[instance].seekRewind(time: time)
    }
    
    //
    
    @objc(play:)
    func play(instance: Int) {
        guard instance >= 0 && instance < PlayerVideo.instances.count else { return }
        
        PlayerVideo.instances[instance].play()
    }
    
    //
    
    @objc(pause:)
    func pause(instance: Int) {
        guard instance >= 0 && instance < PlayerVideo.instances.count else { return }
        
        PlayerVideo.instances[instance].pause()
    }
    
    
    //
    
    @objc(stop:)
    func stop(instance: Int) {
        guard instance >= 0 && instance < PlayerVideo.instances.count else { return }
        
        PlayerVideo.instances[instance].stop()
    }
    
    //
    
    @objc(clear)
    func clear() {
        PlayerVideo.clear()
    }
    
    //
    
    @objc(getDuration:resolver:rejecter:)
    func getDuration(instance: Int, resolver resolve:RCTPromiseResolveBlock, rejecter reject:RCTPromiseRejectBlock) {
        guard instance >= 0 && instance < PlayerVideo.instances.count else {
          resolve(0)
          return
        }
        
        let duration = PlayerVideo.instances[instance].duration
        resolve(duration)
    }
    
   
}
