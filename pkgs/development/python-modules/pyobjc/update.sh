#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts curl esh git jq
# shellcheck shell=bash

set -eou pipefail

cd "$(dirname "$0")" || exit
root=../../../..

get_package_vars() {
  local package="$1"
  local package_json version url

  package_json=$(curl -s https://pypi.org/pypi/"$package"/json)
  version=$(echo "$package_json" | jq --raw-output '.info.version')
  url=$(echo "$package_json" | jq --raw-output ".releases.\"${version}\"[] | select(.packagetype == \"sdist\") | .url")

  echo "$version" "$url"
}

get_hash() {
  local url="$1"

  mapfile -t prefetch < <(nix-prefetch-url --print-path "$url")
  hash=${prefetch[0]}

  echo "$hash"
}

generate_framework_nix() {
  local framework="$1"
  local package="pyobjc-framework-$framework"
  local version url path hash
  local patch= build_frameworks= python_frameworks= tests=

  read -r version url < <(get_package_vars "$package")
  read -r hash < <(get_hash "$url")
  path=../$package/default.nix

  case $framework in
    Accounts)
      python_frameworks="Cocoa"
      tests=true
      ;;
    AddressBook)
      build_frameworks="AddressBook Foundation"
      python_frameworks="Cocoa"
      tests=true
      ;;
    AdSupport)
      python_frameworks="Cocoa"
      tests=true
      ;;
    AppleScriptObjC)
      python_frameworks="Cocoa"
      tests=true
      ;;
    AppleScriptKit)
      python_frameworks="Cocoa"
      tests=true
      ;;
    ApplicationServices)
      python_frameworks="CoreText Quartz"
      tests=true
      ;;
    AuthenticationServices)
      build_frameworks="AuthenticationServices Foundation"
      tests=true
      ;;
    AutomaticAssessmentConfiguration)
      python_frameworks="Cocoa"
      # tests are broken and don't work
      tests=false
      ;;
    Automator)
      python_frameworks="Cocoa"
      tests=true
      ;;
    AVFoundation)
      build_frameworks="AVFoundation Foundation"
      python_frameworks="Cocoa CoreMedia Quartz"
      tests=true
      ;;
    AVKit)
      build_frameworks="AVKit Foundation"
      python_frameworks="Quartz"
      tests=true
      ;;
    BusinessChat)
      python_frameworks="Cocoa"
      tests=true
      ;;
    CalendarStore)
      python_frameworks="Cocoa"
      tests=true
      ;;
    CFNetwork)
      build_frameworks="Foundation"
      python_frameworks="Cocoa"
      tests=true
      ;;
    CloudKit)
      python_frameworks="Accounts CoreData CoreLocation"
      tests=true
      ;;
    Cocoa)
      patch="./tests.patch"
      build_frameworks="AppKit Foundation"
      tests=true
      ;;
    Collaboration)
      python_frameworks="Cocoa"
      tests=true
      ;;
    ColorSync)
      python_frameworks="Cocoa"
      test=true
      ;;
    Contacts)
      build_frameworks="Contacts Foundation"
      python_frameworks="Cocoa"
      tests=true
      ;;
    ContactsUI)
      build_frameworks="ContactsUI Foundation"
      python_frameworks="Contacts"
      tests=true
      ;;
    CoreAudio)
      build_frameworks="Foundation"
      python_frameworks="Cocoa"
      tests=true
      ;;
    CoreAudioKit)
      build_frameworks="CoreAudioKit Foundation"
      python_frameworks="CoreAudio"
      tests=true
      ;;
    CoreBluetooth)
      build_frameworks="CoreBluetooth Foundation"
      python_frameworks="Cocoa"
      tests=true
      ;;
    CoreData)
      build_frameworks="Foundation"
      python_frameworks="Cocoa"
      tests=false
      ;;
    CoreHaptics)
      python_frameworks="Cocoa"
      test=true
      ;;
    CoreLocation)
      build_frameworks="CoreLocation Foundation"
      python_frameworks="Cocoa"
      test=false
      ;;
    CoreMedia)
      build_frameworks="CoreMedia Foundation"
      python_frameworks="Cocoa"
      tests=true
      ;;
    CoreMediaIO)
      build_frameworks="CoreMediaIO Foundation"
      python_frameworks="Cocoa"
      tests=true
      ;;
    CoreML)
      build_frameworks="CoreML Foundation"
      tests=true
      ;;
    CoreMotion)
      python_frameworks="Cocoa"
      tests=true
      ;;
    CoreServices)
      build_frameworks="Foundation"
      python_frameworks="FSEvents"
      tests=false
      ;;
    CoreSpotlight)
      build_frameworks="CoreSpotlight Foundation"
      tests=true
      ;;
    CoreText)
      build_frameworks="Foundation"
      python_frameworks="Quartz"
      tests=false
      ;;
    CoreWLAN)
      build_frameworks="Foundation"
      python_frameworks="Cocoa"
      tests=true
      ;;
    CryptoTokenKit)
      build_frameworks="CryptoTokenKit Foundation"
      python_frameworks="Cocoa"
      tests=true
      ;;
    DeviceCheck)
      python_frameworks="Cocoa"
      tests=true
      ;;
    DictionaryServices)
      python_frameworks="CoreServices"
      tests=false
      ;;
    DiscRecording)
      build_frameworks="DiscRecording Foundation"
      python_frameworks="Cocoa"
      tests=false
      ;;
    DiscRecordingUI)
      python_frameworks="Cocoa DiscRecording"
      tests=false
      ;;
    DiskArbitration)
      python_frameworks="Cocoa"
      tests=false
      ;;
    DVDPlayback)
      python_frameworks="Cocoa"
      tests=false
      ;;
    EventKit)
      python_frameworks="Cocoa"
      tests=false
      ;;
    ExceptionHandling)
      python_frameworks="Cocoa"
      test=false
      ;;
    ExecutionPolicy)
      python_frameworks="Cocoa"
      test=true
      ;;
    ExternalAccessory)
      build_frameworks="ExternalAccessory Foundation"
      test=true
      ;;
    FileProvider)
      python_frameworks="Cocoa"
      tests=true
      ;;
    FileProviderUI)
      python_frameworks="FileProvider"
      tests=true
      ;;
    FinderSync)
      python_frameworks="Cocoa"
      test=false
      ;;
    FSEvents)
      build_frameworks="Foundation"
      python_frameworks="Cocoa"
      tests=false
      ;;
    GameCenter)
      build_frameworks="Foundation GameKit"
      python_frameworks="Cocoa"
      tests=false
      ;;
    GameController)
      python_frameworks="Cocoa"
      tests=false
      ;;
    GameKit)
      build_frameworks="AddressBook Foundation GameKit"
      python_frameworks="Quartz"
      tests=false
      ;;
    GameplayKit)
      build_frameworks="Foundation GameplayKit"
      python_frameworks="SpriteKit"
      tests=true
      ;;
    ImageCaptureCore)
      build_frameworks="Foundation ImageCaptureCore"
      python_frameworks="Cocoa"
      tests=false
      ;;
    IMServicePlugIn)
      build_frameworks="Foundation IMServicePlugIn"
      python_frameworks="Cocoa"
      tests=false
      ;;
    InputMethodKit)
      build_frameworks="Cocoa Foundation InputMethodKit"
      python_frameworks="Cocoa"
      tests=false
      ;;
    InstallerPlugins)
      python_frameworks="Cocoa"
      tests=false
      ;;
    InstantMessage)
      python_frameworks="Cocoa Quartz"
      tests=true
      ;;
    Intents)
      build_frameworks="Foundation Intents"
      python_frameworks="Cocoa"
      tests=false
      ;;
    IOSurface)
      python_frameworks="Cocoa"
      tests=false
      ;;
    iTunesLibrary)
      python_frameworks="Cocoa"
      tests=true
      ;;
    LatentSemanticMapping)
      python_frameworks="Cocoa"
      tests=false
      ;;
    LaunchServices)
      python_frameworks="CoreServices"
      tests=true
      ;;
    libdispatch)
      build_frameworks="Foundation"
      tests=true
      ;;
    LinkPresentation)
      python_frameworks="Quartz"
      tests=true
      ;;
    LocalAuthentication)
      python_frameworks="Cocoa"
      tests=false
      ;;
    MapKit)
      build_frameworks="Foundation MapKit"
      python_frameworks="CoreLocation Quartz"
      tests=false
      ;;
    MediaAccessibility)
      python_frameworks="Cocoa"
      tests=false
      ;;
    MediaLibrary)
      python_frameworks="Cocoa Quartz"
      tests=false
      ;;
    MediaPlayer)
      python_frameworks="AVFoundation"
      tests=true
      ;;
    MediaToolbox)
      build_frameworks="Foundation MediaToolbox"
      python_frameworks="Cocoa"
      tests=false
      ;;
    Metal)
      build_frameworks="Foundation Metal"
      python_frameworks="Cocoa"
      tests=true
      ;;
    MetalKit)
      build_frameworks="Foundation MetalKit"
      python_frameworks="Cocoa Metal"
      tests=false
      ;;
    ModelIO)
      build_frameworks="Foundation ModelIO"
      python_frameworks="Quartz"
      tests=false
      ;;
    MultipeerConnectivity)
      build_frameworks="Foundation MultipeerConnectivity"
      python_frameworks="Cocoa"
      tests=false
      ;;
    NaturalLanguage)
      python_frameworks="Cocoa"
      tests=false
      ;;
    NetFS)
      python_frameworks="Cocoa"
      tests=true
      ;;
    Network)
      build_frameworks="Foundation Network"
      tests=true
      ;;
    NetworkExtension)
      build_frameworks="AddressBook Foundation NetworkExtension"
      python_frameworks="Cocoa"
      tests=false
      ;;
    NotificationCenter)
      build_frameworks="Foundation NotificationCenter"
      python_frameworks="Cocoa"
      tests=false
      ;;
    OpenDirectory)
      python_frameworks="Cocoa"
      tests=false
      ;;
    OSAKit)
      python_frameworks="Cocoa"
      tests=true
      ;;
    OSLog)
      build_frameworks="Foundation OSLog"
      tests=true
      ;;
    PencilKit)
      python_frameworks="Cocoa"
      tests=true
      ;;
    Photos)
      build_frameworks="Foundation Photos"
      python_frameworks="Cocoa"
      tests=false
      ;;
    PhotosUI)
      build_frameworks="Foundation PhotosUI"
      python_frameworks="Cocoa"
      tests=false
      ;;
    PreferencePanes)
      python_frameworks="Cocoa"
      tests=false
      ;;
    PushKit)
      build_frameworks="Foundation PushKit"
      tests=true
      ;;
    Quartz)
      build_frameworks="AppKit CoreVideo Foundation Quartz"
      python_frameworks="Cocoa"
      tests=false
      ;;
    QuickLookThumbnailing)
      python_frameworks="Quartz"
      tests=true
      ;;
    SafariServices)
      build_frameworks="Foundation SafariServices"
      python_frameworks="Cocoa"
      tests=false
      ;;
    SceneKit)
      build_frameworks="Foundation SceneKit"
      python_frameworks="Cocoa Quartz"
      tests=false
      ;;
    ScreenSaver)
      build_frameworks="Foundation ScreenSaver"
      python_frameworks="Cocoa"
      tests=false
      ;;
    ScriptingBridge)
      build_frameworks="Foundation ScriptingBridge"
      python_frameworks="Cocoa"
      tests=false
      ;;
    SearchKit)
      python_frameworks="CoreServices"
      tests=false
      ;;
    Security)
      build_frameworks="Foundation"
      python_frameworks="Cocoa"
      tests=false
      ;;
    SecurityFoundation)
      python_frameworks="Security"
      tests=false
      ;;
    SecurityInterface)
      build_frameworks="Foundation SecurityInterface"
      python_frameworks="Cocoa Security"
      tests=false
      ;;
    ServiceManagement)
      python_frameworks="Cocoa"
      tests=false
      ;;
    Social)
      python_frameworks="Cocoa"
      tests=false
      ;;
    SoundAnalysis)
      python_frameworks="Cocoa"
      tests=true
      ;;
    Speech)
      build_frameworks="Foundation Speech"
      tests=true
      ;;
    SpriteKit)
      build_frameworks="Foundation SpriteKit"
      python_frameworks="Quartz"
      tests=false
      ;;
    StoreKit)
      build_frameworks="Foundation StoreKit"
      python_frameworks="Cocoa"
      tests=false
      ;;
    SyncServices)
      build_frameworks="Foundation SyncServices"
      python_frameworks="CoreData"
      tests=true
      ;;
    SystemConfiguration)
      build_frameworks="Foundation"
      python_frameworks="Cocoa"
      tests=false
      ;;
    SystemExtensions)
      build_frameworks="Foundation SystemExtensions"
      tests=true
      ;;
    UserNotifications)
      build_frameworks="Foundation UserNotifications"
      tests=true
      ;;
    VideoSubscriberAccount)
      python_frameworks="Cocoa"
      tests=true
      ;;
    VideoToolbox)
      build_frameworks="Foundation VideoToolbox"
      python_frameworks="Cocoa CoreMedia Quartz"
      tests=true
      ;;
    Vision)
      build_frameworks="Foundation Vision"
      tests=true
      ;;
    WebKit)
      build_frameworks="WebKit"
      python_frameworks="Cocoa"
      tests=true
      ;;
  esac

  mkdir -p $(dirname "$path")
  echo esh -o "$path" default.nix.esh framework="$framework" version="$version" hash="$hash" build_frameworks="$build_frameworks" python_frameworks="$python_frameworks" patch=$patch tests=$tests
  IFS=' ' esh -o "$path" default.nix.esh framework="$framework" version="$version" hash="$hash" build_frameworks="$build_frameworks" python_frameworks="$python_frameworks" patch=$patch tests=$tests
}

update_package() {
  local package="$1"
  local version="$2"
  local url hash

  if [[ -z $2 ]]; then
    read -r version url < <(get_package_vars "$package")
  fi
  read -r hash get_hash < <(get_hash "$url")

  update-source-version "python3Packages.$package" "$version" "$hash"
}

update_commit_package() {
  local package="$1"
  local commit_message="$2"
  local old_version new_version url

  old_version=$(nix-instantiate --eval --strict -A "python3Packages.$package.version")
  read -r new_version url < <(get_package_vars "$package")

  update_package $package $new_version
  cd $root
  git add pkgs/development/python-modules/$package/default.nix
  if [[ $old_version != $new_version ]]; then
    git commit -m "$package: $old_version -> $new_version"
  else
    git commit -m "$package: $commit_message"
  fi
}

declare -a frameworks=(Accounts AdSupport AddressBook AppleScriptObjC AppleScriptKit ApplicationServices
  AuthenticationServices AutomaticAssessmentConfiguration Automator AVFoundation AVKit BusinessChat CalendarStore CFNetwork CloudKit Cocoa
  Collaboration ColorSync Contacts ContactsUI CoreAudio CoreAudioKit CoreBluetooth CoreData CoreHaptics CoreLocation CoreMedia CoreMediaIO CoreML CoreMotion
  CoreServices CoreSpotlight CoreText CoreWLAN CryptoTokenKit DeviceCheck DictionaryServices
  DiscRecording DiscRecordingUI DiskArbitration DVDPlayback EventKit ExecutionPolicy ExceptionHandling ExternalAccessory
  FileProvider FileProviderUI FinderSync FSEvents GameCenter GameController GameKit GameplayKit
  ImageCaptureCore IMServicePlugIn InputMethodKit InstallerPlugins InstantMessage Intents IOSurface iTunesLibrary LatentSemanticMapping
  LaunchServices libdispatch LinkPresentation LocalAuthentication MapKit Metal MediaAccessibility MediaLibrary
  MediaPlayer MediaToolbox MetalKit ModelIO MultipeerConnectivity NaturalLanguage NetFS Network
  NetworkExtension NotificationCenter OpenDirectory OSAKit OSLog PencilKit Photos PhotosUI PreferencePanes PushKit Quartz
  QuickLookThumbnailing SafariServices SceneKit ScreenSaver ScriptingBridge SearchKit Security
  SecurityFoundation SecurityInterface ServiceManagement Social SoundAnalysis Speech SpriteKit StoreKit SyncServices SystemConfiguration
  SystemExtensions UserNotifications VideoSubscriberAccount VideoToolbox Vision WebKit)

case $1 in
  "-h" | "--help")
    echo "Usage:"
    echo "$0 [-h|--help] [generate|update [NAME]]"
    echo "--help    Show this help."
    echo "auto      Automatically updating, regenrating and commiting all pyobjc* modules."
    echo "generate  Re-generate all pyobjc-framework-* Python packages. Accepts an optional NAME to only update this package."
    echo "update    Update all pyobjc-framework-* Python packages using update-source-version. Accepts an optional NAME to only generate this package."
    ;;
  "auto")
    commit_message="$2"

    update_commit_package pyobjc "$commit_message"
    update_commit_package pyobjc-core "$commit_message"

    for framework in ${frameworks[@]}; do
      update_commit_package pyobjc-framework-$framework "$commit_message"
    done
    ;;
  "generate" | "")
    framework="${2:-}"

    if [[ -n $framework ]]; then
      generate_framework_nix $framework
    else
      for framework in ${frameworks[@]}; do
        generate_framework_nix $framework
      done
    fi
    ;;
  "update")
    framework="$2"

    if [[ -n $framework ]]; then
      update_package pyobjc-framework-$framework
    else
      update_package pyobjc
      update_package pyobjc-core

      for framework in ${frameworks[@]}; do
        update_package pyobjc-framework-$framework
      done
    fi
    ;;
  *)
    echo "Unknown argument $1"
    exit
    ;;
esac
