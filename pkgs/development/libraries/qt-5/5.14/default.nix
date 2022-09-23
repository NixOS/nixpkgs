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
, buildPackages

  # options
, developerBuild ? false
, decryptSslTraffic ? false
, debug ? false
}:

let

  qtCompatVersion = srcs.qtbase.version;

  mirror = "https://download.qt.io";
  srcs = import ./srcs.nix { inherit fetchurl; inherit mirror; } // {
    # qtwebkit does not have an official release tarball on the qt mirror and is
    # mostly maintained by the community.
    qtwebkit = rec {
      src = fetchFromGitHub {
        owner = "qt";
        repo = "qtwebkit";
        rev = "v${version}";
        sha256 = "0x8rng96h19xirn7qkz3lydal6v4vn00bcl0s3brz36dfs0z8wpg";
      };
      version = "5.212.0-alpha4";
    };
  };

  patches = {
    qtbase = lib.optionals stdenv.isDarwin [
      ./qtbase.patch.d/0001-qtbase-mkspecs-mac.patch

      # Downgrade minimal required SDK to 10.12
      ./qtbase.patch.d/0013-define-kiosurfacesuccess.patch
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
    qtlocation = [ ./qtlocation-gcc-9.patch ];
    qtscript = [ ./qtscript.patch ];
    qtserialport = [ ./qtserialport.patch ];
    qtwebengine = [
      # Fix build with bison-3.7: https://code.qt.io/cgit/qt/qtwebengine-chromium.git/commit/?id=1a53f599
      (fetchpatch {
        name = "qtwebengine-bison-3.7-build.patch";
        url = "https://code.qt.io/cgit/qt/qtwebengine-chromium.git/patch/?id=1a53f599";
        sha256 = "1nqpyn5fq37q7i9nasag6i14lnz0d7sld5ikqhlm8qwq9d7gbmjy";
        stripLen = 1;
        extraPrefix = "src/3rdparty/";
      })
      # Fix build with GCC 10 (part 1): https://code.qt.io/cgit/qt/qtwebengine-chromium.git/commit/?id=fad3e27b
      (fetchpatch {
        name = "qtwebengine-gcc10-part1.patch";
        url = "https://code.qt.io/cgit/qt/qtwebengine-chromium.git/patch/?id=fad3e27bfb50d1e23a07577f087a826b5e00bb1d";
        sha256 = "0c55j9zww8jyif6wl7jy1qqidgw9fdhiyfjgzhzi85r716m4pwwd";
        stripLen = 1;
        extraPrefix = "src/3rdparty/";
      })
      # Fix build with GCC 10 (part 2): https://code.qt.io/cgit/qt/qtwebengine-chromium.git/commit/?id=193c5bed
      (fetchpatch {
        name = "qtwebengine-gcc10-part2.patch";
        url = "https://code.qt.io/cgit/qt/qtwebengine-chromium.git/patch/?id=193c5bed1cff123e21b7e6d12f464d6709ace2e3";
        sha256 = "1jb6s32ara6l4rbn4h3gg95mzv8sd8dl1zpjaqwywf1w7p8ymk86";
        stripLen = 1;
        extraPrefix = "src/3rdparty/";
      })

      # glibc 2.34 compat
      (fetchpatch {
        url = "https://src.fedoraproject.org/rpms/qt5-qtwebengine/raw/4cef673b2dd01ce85ce7a841cf352104bbe79668/f/qtwebengine-everywhere-5.15.2-SIGSTKSZ.patch";
        sha256 = "sha256-2D0/FL4PBL4p6ccd6JoDAGqNtLs2aeE1OdM+PJItock=";
      })
    ] ++ lib.optional stdenv.isDarwin ./qtwebengine-darwin-no-platform-check.patch;
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
        inherit debug developerBuild decryptSslTraffic;
        inherit (darwin.apple_sdk.frameworks) AGL AppKit ApplicationServices AVFoundation Carbon Cocoa CoreAudio CoreBluetooth
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
