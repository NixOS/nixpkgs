/*

# Updates

Run `./fetch.sh` to update package sources from Git.
Check for any minor version changes.

*/

{ makeScopeWithSplicing', generateSplicesForMkScope
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
      ./qtbase.patch.d/9999-backport-dbus-crash.patch
    ];
    qtdeclarative = [
      ./qtdeclarative.patch
      # prevent headaches from stale qmlcache data
      ./qtdeclarative-default-disable-qmlcache.patch
    ];
    qtpim = [
      ## Upstream patches after the Qt6 transition that apply without problems & fix bugs

      # Fixes QList -> QSet conversion
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/f337e281e28904741a3b1ac23d15c3a83ef2bbc9.patch";
        hash = "sha256-zlxD45JnbhIgdJxMmGxGMUBcQPcgzpu3s4bLX939jL0=";
      })
      # Fixes invalid syntax from a previous bad patch in tests
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/2aefdd8bd28a4decf9ef8381f5b255f39f1ee90c.patch";
        hash = "sha256-mg93QF3hi50igw1/Ok7fEs9iCaN6co1+p2/5fQtxTmc=";
      })
      # Unit test account for QList index change
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/79b41af6a4117f5efb0298289e20c30b4d0b0b2e.patch";
        hash = "sha256-u+cLl4lu6r2+j5GAiasqbB6/OZPz5A6GpSB33vd/VBg=";
      })
      # Remove invalid method overload which confuses the QML engine
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/5679a6141c76ae7d64c3acc8a87b1adb048289e0.patch";
        hash = "sha256-z8f8kLhC9CqBOfGPL8W9KJq7MwALAAicXfRkHiQEVJ4=";
      })
      # Specify enum flag type properly in unit test
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/a43cc24e57db8d3c3939fa540d67da3294dcfc5c.patch";
        hash = "sha256-SsYkxX6prxi8VRZr4az+wqawcRN8tR3UuIFswJL+3T4=";
      })
      # Update qHash methods to return size_t instead of uint
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/9c698155d82fc2b68a87c59d0443c33f9085b117.patch";
        hash = "sha256-rb8D8taaglhQikYSAPrtLvazgIw8Nga/a9+J21k8gIo=";
      })
      # Mark virtual methods with override keyword
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/f34cf2ff2b0f428d5b8a70763b29088075ebbd1c.patch";
        hash = "sha256-tNPOEVpx1eqHx5T23ueW32KxMQ/SB+TBCJ4PZ6SA3LI=";
      })
      # Fix calendardemo example
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/a66590d473753bc49105d3132fb9e4150c92a14a.patch";
        hash = "sha256-RPRtGQ24NQYewnv6+IqYITpwD/XxuK68a1iKgFmKm3c=";
      })
      # Make the tests pass on big endian systems
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/7802f038ed1391078e27fa3f37d785a69314537b.patch";
        hash = "sha256-hogUXyPXjGE0q53PWOjiQbQ2YzOsvrJ7mo9djGIbjVQ=";
      })
      # Fix some deprecated QChar constructor issues in unit tests
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/114615812dcf9398c957b0833e860befe15f840f.patch";
        hash = "sha256-yZ1qs8y5DSq8FDXRPyuSPRIzjEUTWAhpVide/b+xaLQ=";
      })
      # Accessors should be const
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/a2bf7cdf05c264b5dd2560f799760b5508f154e4.patch";
        hash = "sha256-+YfPrKyOKnPkqFokwW/aDsEivg4TzdJwQpDdAtM+rQE=";
      })
      # Enforce detail access constraints in contact operations by default
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/8765a35233aa21a932ee92bbbb92a5f8edd4dc68.patch";
        hash = "sha256-vp/enerVecEXz4zyxQ66DG+fVVWxI4bYnLj92qaaqNk=";
      })
      # Fixes broken file generation, which breaks reverse dependencies that try to find one of its modules
      (fetchpatch {
        url = "https://github.com/qt/qtpim/commit/4b2bdce30bd0629c9dc0567af6eeaa1d038f3152.patch";
        hash = "sha256-2dXhkZyxPvY2KQq2veerAlpXkpU5/FeArWRlm1aOcEY=";
      })

      ## Patches that haven't been upstreamed

      # Fix tst_QContactManager::compareVariant_data test
      (fetchpatch {
        url = "https://salsa.debian.org/qt-kde-team/qt/qtpim/-/raw/360682f88457b5ae7c92f32f574e51ccc5edbea0/debian/patches/1001_fix-qtdatetime-null-comparison.patch";
        hash = "sha256-k/rO9QjwSlRChwFTZLkxDjZWqFkua4FNbaNf1bJKLxc=";
      })
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
      # Fix version being 0.0.0
      (fetchpatch {
        url = "https://salsa.debian.org/qt-kde-team/qt/qtpim/-/raw/360682f88457b5ae7c92f32f574e51ccc5edbea0/debian/patches/2000_revert_module_version.patch";
        hash = "sha256-6wg/eVu9J83yvIO428U1FX3otz58tAy6pCvp7fqOBKU=";
      })
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
      ./qtwebengine-link-pulseaudio.patch
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
      qtconnectivity = callPackage ../modules/qtconnectivity.nix {
        inherit (darwin.apple_sdk_11_0.frameworks) IOBluetooth;
      };
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
      qtremoteobjects = callPackage ../modules/qtremoteobjects.nix {};
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
    };

  baseScope = makeScopeWithSplicing' {
    otherSplices = generateSplicesForMkScope "qt5";
    f = addPackages;
  };

  bootstrapScope = baseScope.overrideScope(final: prev: {
    qtbase = prev.qtbase.override { qttranslations = null; };
    qtdeclarative = null;
  });

  finalScope = baseScope.overrideScope(final: prev: {
    qttranslations = bootstrapScope.qttranslations;
  });
in finalScope
