/*

# Updates

Before a major version update, make a copy of this directory. (We like to
keep the old version around for a short time after major updates.) Add a
top-level attribute to `top-level/all-packages.nix`.

1. Update the URL in `pkgs/development/libraries/qt-5/$VERSION/fetch.sh`.
2. From the top of the Nixpkgs tree, run
   `./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/$VERSION`.
3. Check that the new packages build correctly.
4. Commit the changes and open a pull request.

*/

{ newScope
, lib, stdenv, fetchurl, fetchpatch, fetchFromGitHub, makeSetupHook, makeWrapper
, bison, cups ? null, harfbuzz, libGL, perl
, gstreamer, gst-plugins-base, gtk3, dconf
, darwin

  # options
, developerBuild ? false
, decryptSslTraffic ? false
, debug ? false
}:

let

  qtCompatVersion = srcs.qtbase.version;

  mirror = "https://download.qt.io";
  srcs = import ./srcs.nix { inherit fetchurl; inherit mirror; } // {
    # Community port of the now unmaintained upstream qtwebkit.
    qtwebkit = rec {
      src = fetchFromGitHub {
        owner = "qtwebkit";
        repo = "qtwebkit";
        rev = "qtwebkit-${version}";
        sha256 = "11lc5sk10d9cyg8jqkbgkqiap72b9rax7hy61nm90zw9749y2yfg";
      };
      version = "5.212.0-alpha4";
    };
  };

  patches = {
    qtbase = [
      ./qtbase.patch.d/0001-qtbase-mkspecs-mac.patch
      ./qtbase.patch.d/0002-qtbase-mac.patch
      ./qtbase.patch.d/0013-define-kiosurfacesuccess.patch

      # Patch framework detection to support X.framework/X.tbd,
      # extending the current support for X.framework/X.
      ./qtbase.patch.d/0015-qtbase-tbd-frameworks.patch

      ./qtbase.patch.d/0003-qtbase-mkspecs.patch
      ./qtbase.patch.d/0004-qtbase-replace-libdir.patch
      ./qtbase.patch.d/0005-qtbase-cmake.patch
      ./qtbase.patch.d/0006-qtbase-gtk3.patch
      ./qtbase.patch.d/0007-qtbase-xcursor.patch
      ./qtbase.patch.d/0008-qtbase-xcompose.patch
      ./qtbase.patch.d/0009-qtbase-tzdir.patch
      ./qtbase.patch.d/0010-qtbase-qtpluginpath.patch
      ./qtbase.patch.d/0011-qtbase-assert.patch
      ./qtbase.patch.d/0012-fix-header_module.patch

      # Ensure -I${includedir} is added to Cflags in pkg-config files.
      # See https://github.com/NixOS/nixpkgs/issues/52457
      ./qtbase.patch.d/0014-qtbase-pkg-config.patch

      # Make Qt applications work on macOS Big Sur even if they're
      # built with an older version of the macOS SDK (<10.14). This
      # issue is fixed in 5.12.11, but it requires macOS SDK 10.13 to
      # build. See https://bugreports.qt.io/browse/QTBUG-87014 for
      # more info.
      (fetchpatch {
        name = "big_sur_layer_backed_views.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtbase.git;a=patch;h=c5d904639dbd690a36306e2b455610029704d821";
        sha256 = "0crkw3j1iwdc1pbf5dhar0b4q3h5gs2q1sika8m12y02yk3ns697";
      })
    ];
    qtdeclarative = [ ./qtdeclarative.patch ];
    qtlocation = [ ./qtlocation-gcc-9.patch ];
    qtscript = [ ./qtscript.patch ];
    qtserialport = [ ./qtserialport.patch ];
    qtwebengine = [
      ./qtwebengine-no-build-skip.patch
      # https://gitlab.freedesktop.org/pulseaudio/pulseaudio/issues/707
      # https://bugreports.qt.io/browse/QTBUG-77037
      (fetchpatch {
        name = "fix-build-with-pulseaudio-13.0.patch";
        url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/fc77d6b3d5ec74e421b58f199efceb2593cbf951/trunk/qtbug-77037-workaround.patch";
        sha256 = "1gv733qfdn9746nbqqxzyjx4ijjqkkb7zb71nxax49nna5bri3am";
      })

      ./qtwebengine-darwin-no-platform-check.patch
      ./qtwebengine-darwin-fix-failed-static-assertion.patch
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

      callPackage = self.newScope { inherit qtCompatVersion qtModule srcs; };
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
        inherit debug developerBuild decryptSslTraffic;
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
        qt3d qtcharts qtconnectivity qtdeclarative qtdoc qtgamepad qtgraphicaleffects
        qtimageformats qtlocation qtmultimedia qtquickcontrols qtquickcontrols2
        qtscript qtsensors qtserialport qtsvg qttools qttranslations
        qtvirtualkeyboard qtwebchannel qtwebengine qtwebkit qtwebsockets
        qtwebview qtx11extras qtxmlpatterns
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
        deps = [ self.qtbase.dev makeWrapper ]
          ++ lib.optional stdenv.isLinux self.qtwayland.dev;
      } ../hooks/wrap-qt-apps-hook.sh;
    };

in lib.makeScope newScope addPackages
