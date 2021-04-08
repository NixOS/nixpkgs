{ lib
, python
, fetchFromGitHub
, stdenvNoCC
, buildPythonPackage
, libffi
, libdispatch
, libobjc
, frameworks
, setuptools
, packaging
}:

let
  version = "7.1";
  macSdkVersion = "10.12";

  meta = with lib; {
    description = "A bridge between the Python and Objective-C programming languages";
    license = licenses.mit;
    maintainers = with maintainers; [ lukegb ];
    homepage = "https://pythonhosted.org/pyobjc/";
    platforms = platforms.darwin;
  };
  src = stdenvNoCC.mkDerivation rec {
    pname = "pyobjc-src";
    inherit version meta;

    src = fetchFromGitHub {
      owner = "ronaldoussoren";
      repo = "pyobjc";
      rev = "af0349674b08126e52f2d055cc5c2d917afc3913";
      sha256 = "1d58hrzwaalssdfg1018n2rg2k2270b30c7gb1w0nk6q3r3fccq2";
    };

    patches = [
      # Read macOS SDK version from environment variable, rather than using system version.
      ./macos-sdk-version.patch
      ./pyobjc-setup-sdk-version.patch

      # Fix LaunchServices/CoreServices.LaunchServices.
      ./launch-services.patch

      # We don't package the iTunesLibrary framework.
      ./pyobjc-setup-drop-itunes.patch
    ];

    postPatch = ''
      substituteInPlace pyobjc-core/Modules/objc/libffi_support.h \
        --replace "ffi/ffi.h" "ffi.h"

      for f in pyobjc-framework-*/pyobjc_setup.py; do
        cp pyobjc-core/Tools/pyobjc_setup.py "$f"
      done
    '';

    buildPhase = "true";
    installPhase = ''
      cp -R . $out
    '';
  };

  subdir = name: attrs: let
    frameworkInputs = lib.optionals (attrs ? frameworks) attrs.frameworks;
    buildInputs = lib.optionals (attrs ? buildInputs) attrs.buildInputs;
    deps = lib.optionals (attrs ? deps) attrs.deps;
    skipCoreDep = if attrs ? skipCoreDep then attrs.skipCoreDep else false;
    pythonModuleName = if name == "pyobjc-core" then "objc" else lib.removePrefix "pyobjc-framework-" name;
  in buildPythonPackage {
    pname = name;
    inherit version src;

    sourceRoot = "${src.name}/${name}";
    propagatedBuildInputs = deps ++ lib.optional (!skipCoreDep) modules.pyobjc-core;
    buildInputs = frameworkInputs ++ buildInputs ++ [ libobjc frameworks.Foundation ];

    # Tests for -core don't run, and then the other tests don't work anyway.
    doCheck = false;
    pythonImportsCheck = [ pythonModuleName ];

    NIX_MACOS_SDK_VERSION = macSdkVersion;

    # Don't let them turn warnings into errors.
    NIX_CFLAGS_COMPILE = "-Wno-error";

    # Avoid `clang-7: error: argument unused during compilation: '-fno-strict-overflow' [-Werror,-Wunused-command-line-argument]` spam
    hardeningDisable = ["strictoverflow"];

    preCheck = ''
      # Needed for PyObjCTest.test_bundleFunctions.TestBundleFunctions
      export HOME=/var/empty
    '';

  };

  moduleDeps = with frameworks; with modules; {
    pyobjc-core = {
      frameworks = [ Carbon Cocoa ];
      buildInputs = [ libffi ];
      deps = [ setuptools ];
      skipCoreDep = true;
    };

    pyobjc-framework-AVFoundation = {
      frameworks = [ AVFoundation ];
      deps = [ pyobjc-framework-CoreMedia pyobjc-framework-Cocoa pyobjc-framework-Quartz ];
    };
    pyobjc-framework-AVKit = {
      frameworks = [ AVKit AppKit ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Quartz ];
    };
    pyobjc-framework-Accounts = {
      frameworks = [ Accounts ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-AddressBook = {
      frameworks = [ AddressBook ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-AppleScriptKit = {
      frameworks = [ AppleScriptKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-AppleScriptObjC = {
      frameworks = [ AppleScriptObjC ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-ApplicationServices = {
      frameworks = [ ApplicationServices ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Quartz ];
    };
    pyobjc-framework-Automator = {
      frameworks = [ Automator ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-CFNetwork = {
      frameworks = [ CFNetwork ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-CalendarStore = {
      frameworks = [ CalendarStore ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-CloudKit = {
      frameworks = [ CloudKit ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-CoreLocation pyobjc-framework-CoreData pyobjc-framework-Accounts ];
    };
    pyobjc-framework-Cocoa = {
      frameworks = [ Cocoa ];
      deps = [  ];
    };
    pyobjc-framework-Collaboration = {
      frameworks = [ Collaboration ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-Contacts = {
      frameworks = [ Contacts ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-ContactsUI = {
      frameworks = [ ContactsUI ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Contacts ];
    };
    pyobjc-framework-CoreAudio = {
      frameworks = [ CoreAudio ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-CoreAudioKit = {
      frameworks = [ CoreAudioKit Cocoa ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-CoreAudio ];
    };
    pyobjc-framework-CoreBluetooth = {
      frameworks = [ CoreBluetooth ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-CoreData = {
      frameworks = [ CoreData ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-CoreLocation = {
      frameworks = [ CoreLocation ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-CoreMIDI = {
      frameworks = [ CoreMIDI ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-CoreMedia = {
      frameworks = [ CoreMedia ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-CoreMediaIO = {
      frameworks = [ CoreMediaIO ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-CoreServices = {
      frameworks = [ CoreServices ];
      deps = [ pyobjc-framework-FSEvents ];
    };
    pyobjc-framework-CoreText = {
      frameworks = [ CoreText ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Quartz ];
    };
    pyobjc-framework-CoreWLAN = {
      frameworks = [ CoreWLAN ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-CryptoTokenKit = {
      frameworks = [ CryptoTokenKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-DVDPlayback = {
      frameworks = [ DVDPlayback ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-DictionaryServices = {
      frameworks = [ CoreServices ];
      deps = [ pyobjc-framework-CoreServices ];
    };
    pyobjc-framework-DiscRecording = {
      frameworks = [ DiscRecording ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-DiscRecordingUI = {
      frameworks = [ DiscRecordingUI ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-DiscRecording ];
    };
    pyobjc-framework-DiskArbitration = {
      frameworks = [ DiskArbitration ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-EventKit = {
      frameworks = [ EventKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-ExceptionHandling = {
      frameworks = [ ExceptionHandling ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-FSEvents = {
      frameworks = [ CoreServices ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-FinderSync = {
      frameworks = [ FinderSync ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-GameCenter = {
      frameworks = [ GameCenter GameKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-GameController = {
      frameworks = [ GameController AppKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-GameKit = {
      frameworks = [ GameKit AddressBook ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Quartz ];
    };
    pyobjc-framework-GameplayKit = {
      frameworks = [ GameplayKit MetalKit SpriteKit AppKit Cocoa ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-SpriteKit ];
    };
    pyobjc-framework-IMServicePlugIn = {
      frameworks = [ IMServicePlugIn GameKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-IOSurface = {
      frameworks = [ IOSurface ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-ImageCaptureCore = {
      frameworks = [ ImageCaptureCore ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-InputMethodKit = {
      frameworks = [ InputMethodKit Cocoa ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-InstallerPlugins = {
      frameworks = [ InstallerPlugins ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-InstantMessage = {
      frameworks = [ InstantMessage ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Quartz ];
    };
    pyobjc-framework-Intents = {
      frameworks = [ Intents CoreLocation ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-LatentSemanticMapping = {
      frameworks = [ LatentSemanticMapping ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-LaunchServices = {
      frameworks = [ CoreServices ];
      deps = [ pyobjc-framework-CoreServices ];
    };
    pyobjc-framework-LocalAuthentication = {
      frameworks = [ LocalAuthentication ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-MapKit = {
      frameworks = [ MapKit CoreLocation AppKit ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-CoreLocation pyobjc-framework-Quartz ];
    };
    pyobjc-framework-MediaAccessibility = {
      frameworks = [ MediaAccessibility ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-MediaLibrary = {
      frameworks = [ MediaLibrary ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Quartz ];
    };
    pyobjc-framework-MediaPlayer = {
      frameworks = [ MediaPlayer ];
      deps = [ pyobjc-framework-AVFoundation ];
    };
    pyobjc-framework-MediaToolbox = {
      frameworks = [ MediaToolbox ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-Metal = {
      frameworks = [ Metal ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-MetalKit = {
      frameworks = [ MetalKit AppKit ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Metal ];
    };
    pyobjc-framework-ModelIO = {
      frameworks = [ ModelIO MetalKit ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Quartz ];
    };
    pyobjc-framework-MultipeerConnectivity = {
      frameworks = [ MultipeerConnectivity ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-NetFS = {
      frameworks = [ NetFS ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-NetworkExtension = {
      frameworks = [ NetworkExtension AddressBook ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-NotificationCenter = {
      frameworks = [ NotificationCenter AppKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-OSAKit = {
      frameworks = [ OSAKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-OpenDirectory = {
      frameworks = [ OpenDirectory ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-Photos = {
      frameworks = [ Photos ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-PhotosUI = {
      frameworks = [ PhotosUI ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-PreferencePanes = {
      frameworks = [ PreferencePanes ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-PubSub = {
      frameworks = [ PubSub ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-Quartz = {
      frameworks = [ Quartz AppKit Cocoa ImageCaptureCore ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-SafariServices = {
      frameworks = [ SafariServices AppKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-SceneKit = {
      frameworks = [ SceneKit MetalKit QuartzCore AppKit ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Quartz ];
    };
    pyobjc-framework-ScreenSaver = {
      frameworks = [ ScreenSaver AppKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-ScriptingBridge = {
      frameworks = [ ScriptingBridge ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-SearchKit = {
      frameworks = [ CoreServices ];
      deps = [ pyobjc-framework-CoreServices ];
    };
    pyobjc-framework-Security = {
      frameworks = [ Security ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-SecurityFoundation = {
      frameworks = [ SecurityFoundation ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Security ];
    };
    pyobjc-framework-SecurityInterface = {
      frameworks = [ SecurityInterface Cocoa ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Security ];
    };
    pyobjc-framework-ServiceManagement = {
      frameworks = [ ServiceManagement ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-Social = {
      frameworks = [ Social ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-SpriteKit = {
      frameworks = [ SpriteKit AppKit MetalKit Cocoa ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Quartz ];
    };
    pyobjc-framework-StoreKit = {
      frameworks = [ StoreKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-SyncServices = {
      frameworks = [ SyncServices ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-CoreData ];
    };
    pyobjc-framework-SystemConfiguration = {
      frameworks = [ SystemConfiguration ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-VideoToolbox = {
      frameworks = [ VideoToolbox ];
      deps = [ pyobjc-framework-Cocoa pyobjc-framework-Quartz pyobjc-framework-CoreMedia ];
    };
    pyobjc-framework-WebKit = {
      frameworks = [ WebKit AppKit ];
      deps = [ pyobjc-framework-Cocoa ];
    };
    pyobjc-framework-libdispatch = {
      frameworks = [ libdispatch ];
    };
  };

  modules = builtins.mapAttrs subdir moduleDeps;
in
buildPythonPackage {
  # This package isn't really a package, but it conforms to most of the nixpkgs Python packaging guidelines.
  # It exists to fulfil the purpose of being a "pyobjc" package that can be installed that provides all the expected frameworks.

  pname = "pyobjc";
  inherit version meta src;

  sourceRoot = "${src.name}/pyobjc";
  buildInputs = [ packaging ];
  propagatedBuildInputs = builtins.attrValues modules;

  doCheck = false;
  patches = [
  ];

  NIX_MACOS_SDK_VERSION = macSdkVersion;

  # Expose the subdirectories as their corresponding Python module names under .modules.
  # pyobjc-framework-WebKit -> WebKit, for instance.
  # pyobjc-core is an exception to the rule, and it's named just "objc".
  passthru.modules = (
    lib.mapAttrs' (name: value: lib.nameValuePair (lib.removePrefix "pyobjc-framework-" name) value) (lib.filterAttrs (name: value: lib.hasPrefix "pyobjc-framework-" name) modules)
  ) // {
    objc = modules.pyobjc-core;
  };
}
