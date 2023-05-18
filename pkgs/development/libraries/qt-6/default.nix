{ newScope
, lib
, stdenv
, fetchurl
, fetchpatch
, makeSetupHook
, makeWrapper
, gst_all_1
, libglvnd
, darwin
, buildPackages

  # options
, developerBuild ? false
, debug ? false
}:

let
  srcs = import ./srcs.nix {
    inherit fetchurl;
    mirror = "mirror://qt";
  };

  addPackages = self: with self;
    let
      callPackage = self.newScope ({
        inherit qtModule srcs;
        stdenv = if stdenv.isDarwin then darwin.apple_sdk_11_0.stdenv else stdenv;
      });
    in
    {

      inherit callPackage srcs;

      qtModule = callPackage ./qtModule.nix { };

      qtbase = callPackage ./modules/qtbase.nix {
        withGtk3 = true;
        inherit (srcs.qtbase) src version;
        inherit developerBuild;
        inherit (darwin.apple_sdk_11_0.frameworks)
          AGL AVFoundation AppKit Contacts CoreBluetooth EventKit GSS MetalKit;
        patches = [
          ./patches/0001-qtbase-qmake-always-use-libname-instead-of-absolute-.patch
          ./patches/0002-qtbase-qmake-fix-mkspecs-for-darwin.patch
          ./patches/0003-qtbase-qmake-fix-includedir-in-generated-pkg-config.patch
          ./patches/0004-qtbase-fix-locating-tzdir-on-NixOS.patch
          ./patches/0005-qtbase-deal-with-a-font-face-at-index-0-as-Regular-f.patch
          ./patches/0006-qtbase-qt-cmake-always-use-cmake-from-path.patch
        ];
      };
      env = callPackage ./qt-env.nix { };
      full = env "qt-full-${qtbase.version}" ([
        qt3d
        qt5compat
        qtcharts
        qtconnectivity
        qtdatavis3d
        qtdeclarative
        qtdoc
        qtgrpc
        qthttpserver
        qtimageformats
        qtlanguageserver
        qtlocation
        qtlottie
        qtmultimedia
        qtmqtt
        qtnetworkauth
        qtpositioning
        qtsensors
        qtserialbus
        qtserialport
        qtshadertools
        qtspeech
        qtquick3d
        qtquick3dphysics
        qtquickeffectmaker
        qtquicktimeline
        qtremoteobjects
        qtsvg
        qtscxml
        qttools
        qttranslations
        qtvirtualkeyboard
        qtwebchannel
        qtwebengine
        qtwebsockets
        qtwebview
      ] ++ lib.optionals (!stdenv.isDarwin) [ qtwayland libglvnd ]);

      qt3d = callPackage ./modules/qt3d.nix { };
      qt5compat = callPackage ./modules/qt5compat.nix { };
      qtcharts = callPackage ./modules/qtcharts.nix { };
      qtconnectivity = callPackage ./modules/qtconnectivity.nix {
        inherit (darwin.apple_sdk_11_0.frameworks) IOBluetooth PCSC;
      };
      qtdatavis3d = callPackage ./modules/qtdatavis3d.nix { };
      qtdeclarative = callPackage ./modules/qtdeclarative.nix { };
      qtdoc = callPackage ./modules/qtdoc.nix { };
      qtgrpc = callPackage ./modules/qtgrpc.nix { };
      qthttpserver = callPackage ./modules/qthttpserver.nix { };
      qtimageformats = callPackage ./modules/qtimageformats.nix { };
      qtlanguageserver = callPackage ./modules/qtlanguageserver.nix { };
      qtlocation = callPackage ./modules/qtlocation.nix { };
      qtlottie = callPackage ./modules/qtlottie.nix { };
      qtmultimedia = callPackage ./modules/qtmultimedia.nix {
        inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi;
        inherit (darwin.apple_sdk_11_0.frameworks) VideoToolbox;
      };
      qtmqtt = callPackage ./modules/qtmqtt.nix { };
      qtnetworkauth = callPackage ./modules/qtnetworkauth.nix { };
      qtpositioning = callPackage ./modules/qtpositioning.nix { };
      qtsensors = callPackage ./modules/qtsensors.nix { };
      qtserialbus = callPackage ./modules/qtserialbus.nix { };
      qtserialport = callPackage ./modules/qtserialport.nix { };
      qtshadertools = callPackage ./modules/qtshadertools.nix { };
      qtspeech = callPackage ./modules/qtspeech.nix {
        inherit (darwin.apple_sdk_11_0.frameworks) Cocoa;
      };
      qtquick3d = callPackage ./modules/qtquick3d.nix { };
      qtquick3dphysics = callPackage ./modules/qtquick3dphysics.nix { };
      qtquickeffectmaker = callPackage ./modules/qtquickeffectmaker.nix { };
      qtquicktimeline = callPackage ./modules/qtquicktimeline.nix { };
      qtremoteobjects = callPackage ./modules/qtremoteobjects.nix { };
      qtsvg = callPackage ./modules/qtsvg.nix { };
      qtscxml = callPackage ./modules/qtscxml.nix { };
      qttools = callPackage ./modules/qttools.nix { };
      qttranslations = callPackage ./modules/qttranslations.nix { };
      qtvirtualkeyboard = callPackage ./modules/qtvirtualkeyboard.nix { };
      qtwayland = callPackage ./modules/qtwayland.nix { };
      qtwebchannel = callPackage ./modules/qtwebchannel.nix { };
      qtwebengine = callPackage ./modules/qtwebengine.nix {
        inherit (darwin) bootstrap_cmds cctools xnu;
        inherit (darwin.apple_sdk_11_0) libpm libunwind;
        inherit (darwin.apple_sdk_11_0.libs) sandbox;
        inherit (darwin.apple_sdk_11_0.frameworks)
          AGL AVFoundation Accelerate Cocoa CoreLocation CoreML ForceFeedback
          GameController ImageCaptureCore LocalAuthentication
          MediaAccessibility MediaPlayer MetalKit Network OpenDirectory Quartz
          ReplayKit SecurityInterface Vision;
        xcbuild = buildPackages.xcbuild.override {
          productBuildVer = "20A2408";
        };
      };
      qtwebsockets = callPackage ./modules/qtwebsockets.nix { };
      qtwebview = callPackage ./modules/qtwebview.nix {
        inherit (darwin.apple_sdk_11_0.frameworks) WebKit;
      };

      wrapQtAppsHook = makeSetupHook
        {
          name = "wrap-qt6-apps-hook";
          propagatedBuildInputs = [ buildPackages.makeBinaryWrapper ];
        } ./hooks/wrap-qt-apps-hook.sh;

      qmake = makeSetupHook
        {
          name = "qmake6-hook";
          propagatedBuildInputs = [ self.qtbase.dev ];
          substitutions = {
            inherit debug;
            fix_qmake_libtool = ./hooks/fix-qmake-libtool.sh;
          };
        } ./hooks/qmake-hook.sh;
    };

  # TODO(@Artturin): convert to makeScopeWithSplicing
  # simple example of how to do that in 5568a4d25ca406809530420996d57e0876ca1a01
  self = lib.makeScope newScope addPackages;
in
self
