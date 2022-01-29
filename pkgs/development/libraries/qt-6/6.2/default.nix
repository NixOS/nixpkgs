/*

  # Updates

  Before a major version update, make a copy of this directory. (We like to
  keep the old version around for a short time after major updates.) Add a
  top-level attribute to `top-level/all-packages.nix`.

  1. Update the URL in `pkgs/development/libraries/qt-6/$VERSION/fetch.sh`.
  2. From the top of the Nixpkgs tree, run
  `./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-6/$VERSION`.
  3. Check that the new packages build correctly.
  4. Commit the changes and open a pull request.

*/

{ newScope
, lib
, stdenv
, fetchurl
, fetchgit
, fetchpatch
, fetchFromGitHub
, makeSetupHook
, makeWrapper
, bison
, cups
, harfbuzz
, libGL
, perl
, cmake
, writeText
, gstreamer
, gst-plugins-base
, gtk3
, dconf
, llvmPackages_5
, darwin

  # options
, developerBuild ? false
, decryptSslTraffic ? false
, debug ? false
}:

let

  qtCompatVersion = srcs.qtbase.version;

  stdenvActual = if stdenv.cc.isClang then llvmPackages_5.stdenv else stdenv;

  mirror = "https://download.qt.io";
  srcs = import ./srcs.nix { inherit fetchurl mirror; } // {
    # qtwebkit does not have an official release tarball on the qt mirror and is
    # mostly maintained by the community.
    /* not-yet available for qt6
    qtwebkit = rec {
      src = fetchFromGitHub {
      # https://github.com/qt/qtwebkit
      owner = "qt";
      repo = "qtwebkit";
      rev = "v${version}";
      sha256 = "0x8rng96h19xirn7qkz3lydal6v4vn00bcl0s3brz36dfs0z8wpg";
      };
      version = "5.212.0-alpha4";
    };
    */
  };

  qtModule =
    import ../qtModule.nix
      {
        inherit perl lib cmake writeText;
        # Use a variant of mkDerivation that does not include wrapQtApplications
        # to avoid cyclic dependencies between Qt modules.
        mkDerivation =
          import ../mkDerivation.nix
            { inherit lib debug; wrapQtAppsHook = null; }
            stdenvActual.mkDerivation;
      }
      { inherit self srcs; };

  addPackages = self: with self;
    let
      callPackage = self.newScope { inherit qtCompatVersion qtModule srcs; };
    in
    {

      inherit callPackage qtCompatVersion qtModule srcs;

      mkDerivationWith =
        import ../mkDerivation.nix
          { inherit lib debug; inherit (self) wrapQtAppsHook; };

      mkDerivation = mkDerivationWith stdenvActual.mkDerivation;

      # NOTE large packages:
      # 150min qtdeclarative
      # 90min qtbase
      # 30min qtwayland
      # qtquick3d?

      qtbase = callPackage ../modules/qtbase.nix {
        inherit (srcs.qtbase) src version;
        inherit bison cups harfbuzz libGL dconf gtk3 developerBuild decryptSslTraffic;
        withGtk3 = true;
        inherit (darwin.apple_sdk.frameworks) AGL AppKit ApplicationServices Carbon Cocoa CoreAudio CoreBluetooth
          CoreLocation CoreServices DiskArbitration Foundation OpenGL MetalKit IOKit;
        inherit (darwin) libobjc;
      };

      qt3d = callPackage ../modules/qt3d.nix { };
      qt5compat = callPackage ../modules/qt5compat.nix { };
      qtcharts = callPackage ../modules/qtcharts.nix { };
      qtconnectivity = callPackage ../modules/qtconnectivity.nix { };
      qtdeclarative = callPackage ../modules/qtdeclarative.nix { };
      qtdoc = callPackage ../modules/qtdoc.nix { };
      qtimageformats = callPackage ../modules/qtimageformats.nix { };
      #qtlocation = callPackage ../modules/qtlocation.nix {};
      qtmultimedia = callPackage ../modules/qtmultimedia.nix {
        inherit gstreamer gst-plugins-base;
      };

      # experiment
      qtbaseDistbuild = callPackage ../modules/qtbase.distbuild.nix {
        inherit (srcs.qtbase) src version;
        inherit bison cups harfbuzz libGL dconf gtk3 developerBuild decryptSslTraffic;
        withGtk3 = true;
        inherit (darwin.apple_sdk.frameworks) AGL AppKit ApplicationServices Carbon Cocoa CoreAudio CoreBluetooth
          CoreLocation CoreServices DiskArbitration Foundation OpenGL MetalKit IOKit;
        inherit (darwin) libobjc;
      };

      qtnetworkauth = callPackage ../modules/qtnetworkauth.nix { };
      qtpositioning = callPackage ../modules/qtpositioning.nix { };
      qtsensors = callPackage ../modules/qtsensors.nix { };
      qtserialbus = callPackage ../modules/qtserialbus.nix { };
      qtserialport = callPackage ../modules/qtserialport.nix { };
      qtshadertools = callPackage ../modules/qtshadertools.nix { };
      qtquick3d = callPackage ../modules/qtquick3d.nix { };
      qtquicktimeline = callPackage ../modules/qtquicktimeline.nix { };
      qtsvg = callPackage ../modules/qtsvg.nix { };
      qtscxml = callPackage ../modules/qtscxml.nix { };
      qttools = callPackage ../modules/qttools.nix { };
      qttranslations = callPackage ../modules/qttranslations.nix { };
      # FIXME cycle error
      # qtvirtualkeyboard = callPackage ../modules/qtvirtualkeyboard.nix {};
      qtwayland = callPackage ../modules/qtwayland.nix { };
      qtwebchannel = callPackage ../modules/qtwebchannel.nix { };
      qtwebengine = callPackage ../modules/qtwebengine.nix {
        inherit (srcs.qtwebengine) version;
        inherit (darwin) cctools libobjc libunwind xnu;
        inherit (darwin.apple_sdk.libs) sandbox;
        inherit (darwin.apple_sdk.frameworks) ApplicationServices AVFoundation Foundation ForceFeedback GameController AppKit
          ImageCaptureCore CoreBluetooth IOBluetooth CoreWLAN Quartz Cocoa LocalAuthentication;
      };
      /*
      qtwebkit = callPackage ../modules/qtwebkit.nix {
        inherit (darwin) ICU;
        inherit (darwin.apple_sdk.frameworks) OpenGL;
      };
      */
      qtwebsockets = callPackage ../modules/qtwebsockets.nix { };
      qtwebview = callPackage ../modules/qtwebview.nix {
        inherit (darwin.apple_sdk.frameworks) CoreFoundation WebKit;
      };

      env = callPackage ../qt-env.nix { };
      full = env "qt-full-${qtbase.version}" ([
        qt3d
        qtcharts
        qtconnectivity
        qtdeclarative
        qtdoc
        qtimageformats
        # qtlocation
        qtmultimedia
        qtsensors
        qtserialport
        qtsvg
        qttools
        qttranslations
        # FIXME cycle error
        # qtvirtualkeyboard
        qtwebchannel
        qtwebengine
        # qtwebkit
        qtwebsockets
        qtwebview
      ] ++ lib.optional (!stdenv.isDarwin) qtwayland);

      qmake = makeSetupHook
        {
          deps = [ self.qtbase.dev ];
          substitutions = {
            inherit debug;
            fix_qmake_libtool = ../hooks/fix-qmake-libtool.sh;
          };
        } ../hooks/qmake-hook.sh;

      qmake2cmake = callPackage ../qmake2cmake.nix { inherit srcs; };

      wrapQtAppsHook = makeSetupHook
        {
          deps = [ self.qtbase.dev makeWrapper ]
            ++ lib.optional stdenv.isLinux self.qtwayland.dev;
        } ../hooks/wrap-qt-apps-hook.sh;
    };

  self = lib.makeScope newScope addPackages;

in
self
