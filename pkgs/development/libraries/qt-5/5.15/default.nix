/*

# Updates

Run `./fetch.sh` to update package sources from Git.
Check for any minor version changes.

*/

{ newScope
, lib, stdenv, fetchurl, fetchgit, fetchpatch, fetchFromGitHub, makeSetupHook, makeWrapper
, bison, cups ? null, harfbuzz, libGL, perl
, gstreamer, gst-plugins-base, gtk3, dconf
, darwin
, buildPackages

  # options
, developerBuild ? false
, decryptSslTraffic ? false
, debug ? false
}:

let

  srcs = import ./srcs.nix { inherit lib fetchgit fetchFromGitHub; };

  qtCompatVersion = srcs.qtbase.version;

  patches = {
    qtbase = lib.optionals stdenv.isDarwin [
      ./qtbase.patch.d/0001-qtbase-mkspecs-mac.patch

      # Downgrade minimal required SDK to 10.12
      ./qtbase.patch.d/0013-define-kiosurfacesuccess.patch
      ./qtbase.patch.d/macos-sdk-10.12/0001-Revert-QCocoaDrag-set-image-only-on-the-first-drag-i.patch
      ./qtbase.patch.d/macos-sdk-10.12/0002-Revert-QCocoaDrag-drag-make-sure-clipboard-is-ours-a.patch
      ./qtbase.patch.d/macos-sdk-10.12/0003-Revert-QCocoaDrag-maybeDragMultipleItems-fix-erroneo.patch
      ./qtbase.patch.d/macos-sdk-10.12/0004-Revert-QCocoaDrag-avoid-using-the-deprecated-API-if-.patch
      ./qtbase.patch.d/macos-sdk-10.12/0005-Revert-macOS-Fix-use-of-deprecated-NSOffState.patch
      ./qtbase.patch.d/macos-sdk-10.12/0006-git-checkout-v5.15.0-src-plugins-platforms-cocoa-qco.patch
      ./qtbase.patch.d/qtbase-sdk-10.12-mac.patch

      # Patch framework detection to support X.framework/X.tbd,
      # extending the current support for X.framework/X.
      ./qtbase.patch.d/0012-qtbase-tbd-frameworks.patch
    ] ++ [
      ./qtbase.patch.d/0003-qtbase-mkspecs.patch
      ./qtbase.patch.d/0004-qtbase-replace-libdir.patch
      ./qtbase.patch.d/0005-qtbase-cmake.patch
      ./qtbase.patch.d/0006-qtbase-gtk3.patch
      ./qtbase.patch.d/0007-qtbase-xcursor.patch
      ./qtbase.patch.d/0008-qtbase-tzdir.patch
      ./qtbase.patch.d/0009-qtbase-qtpluginpath.patch
      ./qtbase.patch.d/0010-qtbase-assert.patch
      ./qtbase.patch.d/0011-fix-header_module.patch
    ];
    qtdeclarative = [ ./qtdeclarative.patch ];
    qtscript = [ ./qtscript.patch ];
    qtserialport = [ ./qtserialport.patch ];
    qtwebengine = lib.optionals stdenv.isDarwin [
      ./qtwebengine-darwin-no-platform-check.patch
      ./qtwebengine-mac-dont-set-dsymutil-path.patch
    ];
    qtwebkit = [
      (fetchpatch {
        name = "qtwebkit-bison-3.7-build.patch";
        url = "https://github.com/qtwebkit/qtwebkit/commit/d92b11fea65364fefa700249bd3340e0cd4c5b31.patch";
        sha256 = "0h8ymfnwgkjkwaankr3iifiscsvngqpwb91yygndx344qdiw9y0n";
      })
      (fetchpatch {
        name = "qtwebkit-glib-2.68.patch";
        url = "https://github.com/qtwebkit/qtwebkit/pull/1058/commits/5b698ba3faffd4e198a45be9fe74f53307395e4b.patch";
        sha256 = "0a3xv0h4lv8wggckgy8cg8xnpkg7n9h45312pdjdnnwy87xvzss0";
      })
      (fetchpatch {
        name = "qtwebkit-darwin-handle.patch";
        url = "https://github.com/qtwebkit/qtwebkit/commit/5c272a21e621a66862821d3ae680f27edcc64c19.patch";
        sha256 = "9hjqLyABz372QDgoq7nXXXQ/3OXBGcYN1/92ekcC3WE=";
      })
      ./qtwebkit.patch
      ./qtwebkit-icu68.patch
    ] ++ lib.optionals stdenv.isDarwin [
      ./qtwebkit-darwin-no-readline.patch
      ./qtwebkit-darwin-no-qos-classes.patch
    ];
    qttools = [ ./qttools.patch ];
  };

  addPackages = self: with self;
    let
      qtModule =
        import ../qtModule.nix
        {
          inherit perl;
          inherit lib;
          # Use a variant of mkDerivation that does not include wrapQtApplications
          # to avoid cyclic dependencies between Qt modules.
          mkDerivation =
            import ../mkDerivation.nix
            { inherit lib; inherit debug; wrapQtAppsHook = null; }
            stdenv.mkDerivation;
        }
        { inherit self srcs patches; };

      callPackage = self.newScope { inherit qtCompatVersion qtModule srcs stdenv; };
    in {

      inherit callPackage qtCompatVersion qtModule srcs;

      mkDerivationWith =
        import ../mkDerivation.nix
        { inherit lib; inherit debug; inherit (self) wrapQtAppsHook; };

      mkDerivation = mkDerivationWith stdenv.mkDerivation;

      qtbase = callPackage ../modules/qtbase.nix {
        inherit (srcs.qtbase) src version;
        patches = patches.qtbase;
        inherit bison cups harfbuzz libGL;
        withGtk3 = !stdenv.isDarwin; inherit dconf gtk3;
        inherit developerBuild decryptSslTraffic;
        inherit (darwin.apple_sdk.frameworks) AGL AppKit ApplicationServices Carbon Cocoa CoreAudio CoreBluetooth
          CoreLocation CoreServices DiskArbitration Foundation OpenGL MetalKit IOKit;
        inherit (darwin) libobjc;
      };

      qt3d = callPackage ../modules/qt3d.nix {};
      qtcharts = callPackage ../modules/qtcharts.nix {};
      qtconnectivity = callPackage ../modules/qtconnectivity.nix {};
      qtdeclarative = callPackage ../modules/qtdeclarative.nix {};
      qtdoc = callPackage ../modules/qtdoc.nix {};
      qtgamepad = callPackage ../modules/qtgamepad.nix {
        inherit (darwin.apple_sdk.frameworks) GameController;
      };
      qtgraphicaleffects = callPackage ../modules/qtgraphicaleffects.nix {};
      qtimageformats = callPackage ../modules/qtimageformats.nix {};
      qtlocation = callPackage ../modules/qtlocation.nix {};
      qtlottie = callPackage ../modules/qtlottie.nix {};
      qtmacextras = callPackage ../modules/qtmacextras.nix {};
      qtmultimedia = callPackage ../modules/qtmultimedia.nix {
        inherit gstreamer gst-plugins-base;
      };
      qtnetworkauth = callPackage ../modules/qtnetworkauth.nix {};
      qtquick1 = null;
      qtquickcontrols = callPackage ../modules/qtquickcontrols.nix {};
      qtquickcontrols2 = callPackage ../modules/qtquickcontrols2.nix {};
      qtscript = callPackage ../modules/qtscript.nix {};
      qtsensors = callPackage ../modules/qtsensors.nix {};
      qtserialbus = callPackage ../modules/qtserialbus.nix {};
      qtserialport = callPackage ../modules/qtserialport.nix {};
      qtspeech = callPackage ../modules/qtspeech.nix {};
      qtsvg = callPackage ../modules/qtsvg.nix {};
      qtscxml = callPackage ../modules/qtscxml.nix {};
      qttools = callPackage ../modules/qttools.nix {};
      qttranslations = callPackage ../modules/qttranslations.nix {};
      qtvirtualkeyboard = callPackage ../modules/qtvirtualkeyboard.nix {};
      qtwayland = callPackage ../modules/qtwayland.nix {};
      qtwebchannel = callPackage ../modules/qtwebchannel.nix {};
      qtwebengine = callPackage ../modules/qtwebengine.nix {
        inherit (srcs.qtwebengine) version;
        inherit (darwin) cctools libobjc libunwind xnu;
        inherit (darwin.apple_sdk.libs) sandbox;
        inherit (darwin.apple_sdk.frameworks) ApplicationServices AVFoundation Foundation ForceFeedback GameController AppKit
          ImageCaptureCore CoreBluetooth IOBluetooth CoreWLAN Quartz Cocoa LocalAuthentication;
      };
      qtwebglplugin = callPackage ../modules/qtwebglplugin.nix {};
      qtwebkit = callPackage ../modules/qtwebkit.nix {
        inherit (darwin) ICU;
        inherit (darwin.apple_sdk.frameworks) OpenGL;
      };
      qtwebsockets = callPackage ../modules/qtwebsockets.nix {};
      qtwebview = callPackage ../modules/qtwebview.nix {
        inherit (darwin.apple_sdk.frameworks) CoreFoundation WebKit;
      };
      qtx11extras = callPackage ../modules/qtx11extras.nix {};
      qtxmlpatterns = callPackage ../modules/qtxmlpatterns.nix {};

      env = callPackage ../qt-env.nix {};
      full = env "qt-full-${qtbase.version}" ([
        qt3d qtcharts qtconnectivity qtdeclarative qtdoc qtgraphicaleffects
        qtimageformats qtlocation qtmultimedia qtquickcontrols qtquickcontrols2
        qtscript qtsensors qtserialport qtsvg qttools qttranslations
        qtvirtualkeyboard qtwebchannel qtwebengine qtwebkit qtwebsockets
        qtwebview qtx11extras qtxmlpatterns qtlottie
      ] ++ lib.optional (!stdenv.isDarwin) qtwayland
        ++ lib.optional (stdenv.isDarwin) qtmacextras);

      qmake = makeSetupHook {
        deps = [ self.qtbase.dev ];
        substitutions = {
          inherit debug;
          fix_qmake_libtool = ../hooks/fix-qmake-libtool.sh;
        };
      } ../hooks/qmake-hook.sh;

      wrapQtAppsHook = makeSetupHook {
        deps = [ self.qtbase.dev buildPackages.makeWrapper ]
          ++ lib.optional stdenv.isLinux self.qtwayland.dev;
      } ../hooks/wrap-qt-apps-hook.sh;
    };

in lib.makeScope newScope addPackages
