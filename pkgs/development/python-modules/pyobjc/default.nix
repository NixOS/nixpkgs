{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, darwin, pyobjc-core
, pyobjc-framework-AddressBook, pyobjc-framework-AdSupport, pyobjc-framework-AppleScriptObjC
, pyobjc-framework-AppleScriptKit, pyobjc-framework-ApplicationServices, pyobjc-framework-AuthenticationServices
, pyobjc-framework-AutomaticAssessmentConfiguration, pyobjc-framework-Automator, pyobjc-framework-AVFoundation
, pyobjc-framework-AVKit, pyobjc-framework-BusinessChat, pyobjc-framework-CalendarStore, pyobjc-framework-CFNetwork
, pyobjc-framework-CloudKit, pyobjc-framework-Cocoa, pyobjc-framework-Collaboration, pyobjc-framework-ColorSync
, pyobjc-framework-ContactsUI, pyobjc-framework-CoreAudio, pyobjc-framework-CoreAudioKit, pyobjc-framework-CoreBluetooth
, pyobjc-framework-CoreHaptics, pyobjc-framework-CoreMedia, pyobjc-framework-CoreMediaIO, pyobjc-framework-CoreMotion
, pyobjc-framework-CoreML, pyobjc-framework-CoreServices, pyobjc-framework-CoreSpotlight, pyobjc-framework-CoreText
, pyobjc-framework-CoreWLAN, pyobjc-framework-CryptoTokenKit, pyobjc-framework-DeviceCheck
, pyobjc-framework-DictionaryServices, pyobjc-framework-DiscRecording, pyobjc-framework-DiscRecordingUI
, pyobjc-framework-DiskArbitration, pyobjc-framework-DVDPlayback, pyobjc-framework-EventKit
, pyobjc-framework-ExceptionHandling, pyobjc-framework-ExecutionPolicy, pyobjc-framework-FileProvider
, pyobjc-framework-FileProviderUI, pyobjc-framework-ExternalAccessory, pyobjc-framework-FinderSync
, pyobjc-framework-GameCenter, pyobjc-framework-GameController, pyobjc-framework-GameKit, pyobjc-framework-GameplayKit
, pyobjc-framework-ImageCaptureCore, pyobjc-framework-IMServicePlugIn, pyobjc-framework-InputMethodKit
, pyobjc-framework-InstallerPlugins, pyobjc-framework-InstantMessage, pyobjc-framework-Intents
, pyobjc-framework-IOSurface, pyobjc-framework-iTunesLibrary, pyobjc-framework-LatentSemanticMapping
, pyobjc-framework-LaunchServices, pyobjc-framework-libdispatch, pyobjc-framework-LinkPresentation
, pyobjc-framework-LocalAuthentication, pyobjc-framework-MapKit, pyobjc-framework-MediaAccessibility
, pyobjc-framework-MediaLibrary, pyobjc-framework-MediaPlayer, pyobjc-framework-MediaToolbox, pyobjc-framework-Metal
, pyobjc-framework-MetalKit, pyobjc-framework-ModelIO, pyobjc-framework-MultipeerConnectivity
, pyobjc-framework-NaturalLanguage, pyobjc-framework-NetFS, pyobjc-framework-Network, pyobjc-framework-NetworkExtension
, pyobjc-framework-NotificationCenter, pyobjc-framework-OpenDirectory, pyobjc-framework-OSAKit, pyobjc-framework-OSLog
, pyobjc-framework-PencilKit, pyobjc-framework-Photos, pyobjc-framework-PhotosUI, pyobjc-framework-PreferencePanes
, pyobjc-framework-PushKit, pyobjc-framework-QuickLookThumbnailing, pyobjc-framework-SafariServices
, pyobjc-framework-SceneKit, pyobjc-framework-ScreenSaver, pyobjc-framework-ScriptingBridge, pyobjc-framework-SearchKit
, pyobjc-framework-Security, pyobjc-framework-SecurityFoundation, pyobjc-framework-SecurityInterface
, pyobjc-framework-ServiceManagement, pyobjc-framework-Social, pyobjc-framework-SoundAnalysis, pyobjc-framework-Speech
, pyobjc-framework-SpriteKit, pyobjc-framework-StoreKit, pyobjc-framework-SyncServices
, pyobjc-framework-SystemConfiguration, pyobjc-framework-SystemExtensions, pyobjc-framework-UserNotifications
, pyobjc-framework-VideoSubscriberAccount, pyobjc-framework-VideoToolbox, pyobjc-framework-Vision, pyobjc-framework-WebKit
}:

buildPythonPackage rec {
  pname = "pyobjc";
  version = "6.2";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04xs0wpz61z45sn9a8v0h61nq6fh0wcn8473h2f5ryrqylv42lbb";
  };

  propagatedBuildInputs = with stdenv.lib; [
    pyobjc-core
    pyobjc-framework-AddressBook pyobjc-framework-AdSupport pyobjc-framework-AppleScriptObjC
    pyobjc-framework-AppleScriptKit pyobjc-framework-ApplicationServices
    pyobjc-framework-AutomaticAssessmentConfiguration pyobjc-framework-Automator pyobjc-framework-AVFoundation
    pyobjc-framework-AVKit pyobjc-framework-BusinessChat pyobjc-framework-CalendarStore pyobjc-framework-CFNetwork
    pyobjc-framework-CloudKit pyobjc-framework-Cocoa pyobjc-framework-Collaboration pyobjc-framework-ColorSync
    pyobjc-framework-ContactsUI pyobjc-framework-CoreAudio pyobjc-framework-CoreAudioKit pyobjc-framework-CoreBluetooth
    pyobjc-framework-CoreHaptics pyobjc-framework-CoreMedia pyobjc-framework-CoreMediaIO pyobjc-framework-CoreMotion
    pyobjc-framework-CoreServices pyobjc-framework-CoreText pyobjc-framework-CoreWLAN pyobjc-framework-CryptoTokenKit
    pyobjc-framework-DeviceCheck pyobjc-framework-DictionaryServices pyobjc-framework-DiscRecording
    pyobjc-framework-DiscRecordingUI pyobjc-framework-DiskArbitration pyobjc-framework-DVDPlayback
    pyobjc-framework-EventKit pyobjc-framework-ExceptionHandling pyobjc-framework-ExecutionPolicy
    pyobjc-framework-FileProvider pyobjc-framework-FileProviderUI pyobjc-framework-FinderSync pyobjc-framework-GameCenter
    pyobjc-framework-GameController pyobjc-framework-GameKit pyobjc-framework-GameplayKit
    pyobjc-framework-ImageCaptureCore pyobjc-framework-IMServicePlugIn pyobjc-framework-InputMethodKit
    pyobjc-framework-InstallerPlugins pyobjc-framework-InstantMessage pyobjc-framework-Intents pyobjc-framework-IOSurface
    pyobjc-framework-iTunesLibrary pyobjc-framework-LatentSemanticMapping pyobjc-framework-LaunchServices
    pyobjc-framework-libdispatch pyobjc-framework-LinkPresentation pyobjc-framework-LocalAuthentication
    pyobjc-framework-MapKit pyobjc-framework-MediaAccessibility pyobjc-framework-MediaLibrary pyobjc-framework-MediaPlayer
    pyobjc-framework-MediaToolbox pyobjc-framework-Metal pyobjc-framework-MetalKit pyobjc-framework-ModelIO
    pyobjc-framework-MultipeerConnectivity pyobjc-framework-NaturalLanguage pyobjc-framework-NetFS
    pyobjc-framework-NetworkExtension pyobjc-framework-NotificationCenter pyobjc-framework-OpenDirectory
    pyobjc-framework-OSAKit pyobjc-framework-PencilKit pyobjc-framework-Photos pyobjc-framework-PhotosUI
    pyobjc-framework-PreferencePanes pyobjc-framework-QuickLookThumbnailing pyobjc-framework-SafariServices
    pyobjc-framework-SceneKit pyobjc-framework-ScreenSaver pyobjc-framework-ScriptingBridge pyobjc-framework-SearchKit
    pyobjc-framework-Security pyobjc-framework-SecurityFoundation pyobjc-framework-SecurityInterface
    pyobjc-framework-ServiceManagement pyobjc-framework-Social pyobjc-framework-SoundAnalysis pyobjc-framework-SpriteKit
    pyobjc-framework-StoreKit pyobjc-framework-SyncServices pyobjc-framework-SystemConfiguration pyobjc-framework-VideoSubscriberAccount pyobjc-framework-VideoToolbox pyobjc-framework-WebKit
  ] ++ optionals (versionOlder "10.13" darwin.apple_sdk.sdk.version )[
    pyobjc-framework-CoreML pyobjc-framework-CoreSpotlight pyobjc-framework-ExternalAccessory pyobjc-framework-Vision
  ] ++ optionals (versionOlder "10.14" darwin.apple_sdk.sdk.version )[
    pyobjc-framework-Network pyobjc-framework-UserNotifications
  ] ++ optionals (versionOlder "10.15" darwin.apple_sdk.sdk.version )[
    pyobjc-framework-AuthenticationServices pyobjc-framework-OSLog pyobjc-framework-PushKit pyobjc-framework-Speech
    pyobjc-framework-SystemExtensions
  ];

  # I suspect that the Python platform check depends on the host and not the Nix Apple SDK
  postPatch = with stdenv.lib; ''
    substituteInPlace setup.py \
      --replace '"test": oc_test, ' ""
  '' + optionalString (versionAtLeast "10.13" darwin.apple_sdk.sdk.version ) ''
    substituteInPlace setup.py \
      --replace '("CoreSpotlight", "10.13", None),' "" \
      --replace '("ExternalAccessory", "10.13", None),' "" \
      --replace '("CoreML", "10.13", None),' "" \
      --replace '("Vision", "10.13", None),' ""
  '' + optionalString (versionAtLeast "10.14" darwin.apple_sdk.sdk.version ) ''
    substituteInPlace setup.py \
      --replace '("Network", "10.14", None),' "" \
      --replace '("UserNotifications", "10.14", None),' ""
  '' + optionalString (versionAtLeast "10.15" darwin.apple_sdk.sdk.version ) ''
    substituteInPlace setup.py \
      --replace '("AuthenticationServices", "10.15", None),' "" \
      --replace '("OSLog", "10.15", None),' "" \
      --replace '("PushKit", "10.15", None),' "" \
      --replace '("Speech", "10.15", None),' "" \
      --replace '("SystemExtensions", "10.15", None),' ""
  '';

  dontUseSetuptoolsCheck = true;
  pythonImportcheck = [ "pyobjc" ];

  meta = with stdenv.lib; {
    description = "The Python <-> Objective-C Bridge with bindings for macOS frameworks";
    license = licenses.mit;
    homepage = "https://pythonhosted.org/pyobjc/";
    maintainers = with maintainers; [ SuperSandro2000 ];
    platforms = platforms.darwin;
  };
}
