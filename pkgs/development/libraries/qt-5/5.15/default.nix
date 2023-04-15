/*

# Updates

Run `./fetch.sh` to update package sources from Git.
Check for any minor version changes.

*/

{ makeScopeWithSplicing, generateSplicesForMkScope
, lib, stdenv, fetchurl, fetchgit, fetchpatch, fetchFromGitHub, makeSetupHook, makeWrapper
, bison, cups ? null, harfbuzz, libGL, perl, python3
, gstreamer, gst-plugins-base, gtk3, dconf
, darwin
, buildPackages

  # options
, developerBuild ? false
, decryptSslTraffic ? false
, debug ? false
, config
}:

let

  srcs = import ./srcs.nix { inherit lib fetchgit fetchFromGitHub; };

  qtCompatVersion = srcs.qtbase.version;

  patches = {
    qtbase = lib.optionals stdenv.isDarwin [
      ./qtbase.patch.d/0001-qtbase-mkspecs-mac.patch

      # Patch framework detection to support X.framework/X.tbd,
      # extending the current support for X.framework/X.
      ./qtbase.patch.d/0012-qtbase-tbd-frameworks.patch

      ./qtbase.patch.d/0014-aarch64-darwin.patch
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
    qtdeclarative = [
      ./qtdeclarative.patch
      # prevent headaches from stale qmlcache data
      ./qtdeclarative-default-disable-qmlcache.patch
    ];
    qtpim = [
      ## Reverts of Qt6-specific changes

      # Remove usages of deprecated QQmlListProperty constructors
      # QML code does not compile with this
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/8f05d1bcba8d2c63d8d85117719b49992bcaea3d.patch";
        revert = true;
        hash = "sha256-XjmW2EpjW+cjaJTulUxLG+85ywp5EE/h0/NKRiEqo54=";
      })

      # Use QMetaType::Type instead of the deprecated QVariant::Type
      # Looks like this would be fine to have in Qt5, but patching failures and build says nah
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/e7607c33998b7c89603e6299d9affcd32e68049a.patch";
        revert = true;
        hash = "sha256-Gp/2tfgIUGYqk+c+2fTBgI4Ii532PONwfjmG9m9E8DU=";
      })

      # Ensure we throw away the BOM in the qversitreader test
      # Description says that something in string encoding works differently "now" (Qt6?), but we don't even run the tests
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/9bcae917730ce083ebb3d45392a4b8ccf57ee306.patch";
        revert = true;
        hash = "sha256-/OHAGoSa2j4aPpEJunBN2TpODQpEosYguQ8ZKNZ+fAU=";
      })

      # Adapt to Qt6 behavior changes
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/0d7a97f0717cef8a16cdba6b37de860a531f9407.patch";
        revert = true;
        hash = "sha256-+ByiLY5+deUctL1O0V1uH/3lAT6SXTcZn2klUjnyAtk=";
      })

      # Add missing include
      # Builds fine without the includes, causes patching failures further down the line unless reverted
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/a86100eb0e37a764399b1e06f73da0ceda5b00e9.patch";
        revert = true;
        hash = "sha256-gqSpCjgDmmD6MXH/D+4iadztrFpakKqaHBSYIl3o5gs=";
      })

      # Don't use QStringRef
      # QStringView preferred in Qt6, but that doesn't matter to us
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/c4769f347111773a96b70b46c7f695847a162ace.patch";
        revert = true;
        hash = "sha256-aCihfoDUjIDVzNdlnYr36uB2wF46nzE3T1w5ah/378k=";
      })

      # QTextCodec is now part of the Qt5Compat library
      # Qt5Compat is a library that eases with porting Qt5->Qt6
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/fdaa78b4ab7f02f9213fdec2a8e18d896d504a45.patch";
        revert = true;
        hash = "sha256-CRl9KhSrgtNmeO199Vns4ZdVM5cVg5sZzLZ5PY3p5LI=";
      })

      ## Patches that haven't been upstreamed

      # Avoid crash while parsing vCards from different threads
      (fetchpatch {
        url = "https://salsa.debian.org/qt-kde-team/qt/qtpim/-/raw/360682f88457b5ae7c92f32f574e51ccc5edbea0/debian/patches/1002_Avoid-crash-while-parsing-vcards-from-different-threads.patch";
        hash = "sha256-zhayAoWgcmKosEGVBy2k6a2e6BxyVwfGX18tBbzqEk8=";
      })

      # Adapt to JSON parser behavior change in Qt 5.15
      (fetchpatch {
        url = "https://salsa.debian.org/qt-kde-team/qt/qtpim/-/raw/360682f88457b5ae7c92f32f574e51ccc5edbea0/debian/patches/1003_adapt_to_json_parser_change.patch";
        hash = "sha256-qAIa48hmDd8vMH/ywqW+22vISKai76XnjgFuB+tQbIU=";
      })

      # MODULE_VERSION was only properly set with Qt6 transition, so extra patch instead of revert
      # https://github.com/qt/qtpim/commit/713bb697fa24f6d6d4e2521ee3db2de237ea6f05
      ./qtpim-MODULE_VERSION.patch
    ];
    qtscript = [ ./qtscript.patch ];
    qtserialport = [ ./qtserialport.patch ];
    qtsystems = [
      # Enable building with udisks support
      (fetchpatch {
        url = "https://salsa.debian.org/qt-kde-team/qt/qtsystems/-/raw/a23fd92222c33479d7f3b59e48116def6b46894c/debian/patches/2001_build_with_udisk.patch";
        hash = "sha256-B/z/+tai01RU/bAJSCp5a0/dGI8g36nwso8MiJv27YM=";
      })
    ];
    qtwebengine = [
      (fetchpatch {
        url = "https://raw.githubusercontent.com/Homebrew/formula-patches/a6f16c6daea3b5a1f7bc9f175d1645922c131563/qt5/qt5-webengine-python3.patch";
        hash = "sha256-rUSDwTucXVP3Obdck7LRTeKZ+JYQSNhQ7+W31uHZ9yM=";
      })
      (fetchpatch {
        url = "https://raw.githubusercontent.com/Homebrew/formula-patches/7ae178a617d1e0eceb742557e63721af949bd28a/qt5/qt5-webengine-chromium-python3.patch";
        stripLen = 1;
        extraPrefix = "src/3rdparty/";
        hash = "sha256-MZGYeMdGzwypfKoSUaa56K3inbcGRx7he/+AFyk5ekA=";
      })
      (fetchpatch {
        url = "https://raw.githubusercontent.com/Homebrew/formula-patches/7ae178a617d1e0eceb742557e63721af949bd28a/qt5/qt5-webengine-gcc12.patch";
        stripLen = 1;
        extraPrefix = "src/3rdparty/";
        hash = "sha256-s4GsGMJTBNWw2gTJuIEP3tqT82AmTsR2mbj59m2p6rM=";
      })
    ] ++ lib.optionals stdenv.isDarwin [
      ./qtwebengine-darwin-no-platform-check.patch
      ./qtwebengine-mac-dont-set-dsymutil-path.patch
      ./qtwebengine-darwin-checks.patch
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
        inherit (darwin.apple_sdk_11_0.frameworks) AGL AppKit ApplicationServices AVFoundation Carbon Cocoa CoreAudio CoreBluetooth
          CoreLocation CoreServices DiskArbitration Foundation OpenGL MetalKit IOKit;
        libobjc = darwin.apple_sdk_11_0.objc4;
        xcbuild = darwin.apple_sdk_11_0.xcodebuild;
      };

      qt3d = callPackage ../modules/qt3d.nix {};
      qtcharts = callPackage ../modules/qtcharts.nix {};
      qtconnectivity = callPackage ../modules/qtconnectivity.nix {};
      qtdatavis3d = callPackage ../modules/qtdatavis3d.nix {};
      qtdeclarative = callPackage ../modules/qtdeclarative.nix {};
      qtdoc = callPackage ../modules/qtdoc.nix {};
      qtgamepad = callPackage ../modules/qtgamepad.nix {
        inherit (darwin.apple_sdk_11_0.frameworks) GameController;
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
      qtpim = callPackage ../modules/qtpim.nix {};
      qtpositioning = callPackage ../modules/qtpositioning.nix {};
      qtquick1 = null;
      qtquickcontrols = callPackage ../modules/qtquickcontrols.nix {};
      qtquickcontrols2 = callPackage ../modules/qtquickcontrols2.nix {};
      qtscript = callPackage ../modules/qtscript.nix {};
      qtsensors = callPackage ../modules/qtsensors.nix {};
      qtserialbus = callPackage ../modules/qtserialbus.nix {};
      qtserialport = callPackage ../modules/qtserialport.nix {};
      qtspeech = callPackage ../modules/qtspeech.nix {};
      qtsvg = callPackage ../modules/qtsvg.nix {};
      qtsystems = callPackage ../modules/qtsystems.nix {};
      qtscxml = callPackage ../modules/qtscxml.nix {};
      qttools = callPackage ../modules/qttools.nix {};
      qttranslations = callPackage ../modules/qttranslations.nix {};
      qtvirtualkeyboard = callPackage ../modules/qtvirtualkeyboard.nix {};
      qtwayland = callPackage ../modules/qtwayland.nix {};
      qtwebchannel = callPackage ../modules/qtwebchannel.nix {};
      qtwebengine = callPackage ../modules/qtwebengine.nix {
        inherit (srcs.qtwebengine) version;
        python = python3;
        postPatch = ''
          # update catapult for python3 compatibility
          rm -r src/3rdparty/chromium/third_party/catapult
          cp -r ${srcs.catapult} src/3rdparty/chromium/third_party/catapult
        '';
        inherit (darwin) cctools xnu;
        inherit (darwin.apple_sdk_11_0) libpm libunwind;
        inherit (darwin.apple_sdk_11_0.libs) sandbox;
        inherit (darwin.apple_sdk_11_0.frameworks) ApplicationServices AVFoundation Foundation ForceFeedback GameController AppKit
          ImageCaptureCore CoreBluetooth IOBluetooth CoreWLAN Quartz Cocoa LocalAuthentication
          MediaPlayer MediaAccessibility SecurityInterface Vision CoreML OpenDirectory Accelerate;
        libobjc = darwin.apple_sdk_11_0.objc4;
      };
      qtwebglplugin = callPackage ../modules/qtwebglplugin.nix {};
      qtwebkit = callPackage ../modules/qtwebkit.nix {
        inherit (darwin) ICU;
        inherit (darwin.apple_sdk_11_0.frameworks) OpenGL;
      };
      qtwebsockets = callPackage ../modules/qtwebsockets.nix {};
      qtwebview = callPackage ../modules/qtwebview.nix {
        inherit (darwin.apple_sdk_11_0.frameworks) CoreFoundation WebKit;
      };
      qtx11extras = callPackage ../modules/qtx11extras.nix {};
      qtxmlpatterns = callPackage ../modules/qtxmlpatterns.nix {};

      env = callPackage ../qt-env.nix {};
      full = env "qt-full-${qtbase.version}" ([
        qt3d qtcharts qtconnectivity qtdeclarative qtdoc qtgraphicaleffects
        qtimageformats qtlocation qtmultimedia qtquickcontrols qtquickcontrols2
        qtscript qtsensors qtserialport qtsvg qttools qttranslations
        qtvirtualkeyboard qtwebchannel qtwebengine qtwebkit qtwebsockets
        qtwebview qtx11extras qtxmlpatterns qtlottie qtdatavis3d
      ] ++ lib.optional (!stdenv.isDarwin) qtwayland
        ++ lib.optional (stdenv.isDarwin) qtmacextras);

      qmake = makeSetupHook {
        name = "qmake-hook";
        propagatedBuildInputs = [ self.qtbase.dev ];
        substitutions = {
          inherit debug;
          fix_qmake_libtool = ../hooks/fix-qmake-libtool.sh;
        };
      } ../hooks/qmake-hook.sh;

      wrapQtAppsHook = makeSetupHook {
        name = "wrap-qt5-apps-hook";
        propagatedBuildInputs = [ self.qtbase.dev buildPackages.makeBinaryWrapper ]
          ++ lib.optional stdenv.isLinux self.qtwayland.dev;
      } ../hooks/wrap-qt-apps-hook.sh;
    } // lib.optionalAttrs config.allowAliases {
      # remove before 23.11
      overrideScope' = lib.warn "qt5 now uses makeScopeWithSplicing which does not have \"overrideScope'\", use \"overrideScope\"." self.overrideScope;
    };

in makeScopeWithSplicing (generateSplicesForMkScope "qt5") (_: {}) (_: {}) addPackages
