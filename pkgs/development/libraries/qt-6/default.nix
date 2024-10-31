{ newScope
, lib
, stdenv
, generateSplicesForMkScope
, makeScopeWithSplicing'
, fetchurl
, fetchpatch2
, makeSetupHook
, makeWrapper
, gst_all_1
, libglvnd
, darwin
, apple-sdk_15
, apple-sdk_12
, darwinMinVersionHook
, buildPackages
, python3
, config
}:

let
  srcs = import ./srcs.nix {
    inherit fetchurl;
    mirror = "mirror://qt";
  };

  addPackages = self:
    let
      callPackage = self.newScope ({
        inherit (self) qtModule;
        inherit srcs python3 stdenv;
      });

      # Per <https://doc.qt.io/qt-6/macos.html#supported-versions>.
      # This should reflect the lowest “Target Platform” and the
      # highest “Build Environment”.
      apple-sdk_qt = apple-sdk_15;
      darwinDeploymentTargetDeps = [
        apple-sdk_12
        (darwinMinVersionHook "12.0")
      ];
    in
    {

      inherit callPackage srcs;

      qtModule = callPackage ./qtModule.nix {
        inherit apple-sdk_qt;
      };

      qtbase = callPackage ./modules/qtbase.nix {
        withGtk3 = !stdenv.hostPlatform.isMinGW;
        inherit apple-sdk_qt darwinDeploymentTargetDeps;
        inherit (srcs.qtbase) src version;
        patches = [
          ./patches/0001-qtbase-qmake-always-use-libname-instead-of-absolute-.patch
          ./patches/0002-qtbase-qmake-fix-mkspecs-for-darwin.patch
          ./patches/0003-qtbase-qmake-fix-includedir-in-generated-pkg-config.patch
          ./patches/0004-qtbase-qt-cmake-always-use-cmake-from-path.patch
          ./patches/0005-qtbase-find-tools-in-PATH.patch
          ./patches/0006-qtbase-pass-to-qmlimportscanner-the-QML2_IMPORT_PATH.patch
          ./patches/0007-qtbase-allow-translations-outside-prefix.patch
          ./patches/0008-qtbase-find-qmlimportscanner-in-macdeployqt-via-envi.patch
          ./patches/0009-qtbase-check-in-the-QML-folder-of-this-library-does-.patch
          ./patches/0010-qtbase-derive-plugin-load-path-from-PATH.patch
          # Backport patch for https://bugs.kde.org/show_bug.cgi?id=493116
          # FIXME: remove for 6.8.1
          (fetchpatch2 {
            url = "https://github.com/qt/qtbase/commit/2ea3abed0125d81ca4f3bacb9650db7314657332.patch";
            hash = "sha256-mdTdwhJtebuLUQRo+y1XUrrzgqG9G7GvPQwvrXLycJI=";
          })

          # Backport patch to fix plugin loading through symlinks
          # FIXME: remove for 6.8.1
          (fetchpatch2 {
            url = "https://github.com/qt/qtbase/commit/e25150ca29437ab315e3686aa801b8636e201e2a.patch";
            hash = "sha256-8WOjjffI48Vlx7gQIiOzfUtPloLys5lf06RQi1lsTys=";
          })
        ];
      };
      env = callPackage ./qt-env.nix { };
      full = callPackage
        ({ env, qtbase }: env "qt-full-${qtbase.version}"
          # `with self` is ok to use here because having these spliced is unnecessary
          (with self;[
            qt3d
            qt5compat
            qtcharts
            qtconnectivity
            qtdatavis3d
            qtdeclarative
            qtdoc
            qtgraphs
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
          ] ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [ qtwayland libglvnd ]))
        { };

      qt3d = callPackage ./modules/qt3d.nix { };
      qt5compat = callPackage ./modules/qt5compat.nix { };
      qtcharts = callPackage ./modules/qtcharts.nix { };
      qtconnectivity = callPackage ./modules/qtconnectivity.nix { };
      qtdatavis3d = callPackage ./modules/qtdatavis3d.nix { };
      qtdeclarative = callPackage ./modules/qtdeclarative.nix { };
      qtdoc = callPackage ./modules/qtdoc.nix { };
      qtgraphs = callPackage ./modules/qtgraphs.nix { };
      qtgrpc = callPackage ./modules/qtgrpc.nix { };
      qthttpserver = callPackage ./modules/qthttpserver.nix { };
      qtimageformats = callPackage ./modules/qtimageformats.nix { };
      qtlanguageserver = callPackage ./modules/qtlanguageserver.nix { };
      qtlocation = callPackage ./modules/qtlocation.nix { };
      qtlottie = callPackage ./modules/qtlottie.nix { };
      qtmultimedia = callPackage ./modules/qtmultimedia.nix {
        inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi;
      };
      qtmqtt = callPackage ./modules/qtmqtt.nix { };
      qtnetworkauth = callPackage ./modules/qtnetworkauth.nix { };
      qtpositioning = callPackage ./modules/qtpositioning.nix { };
      qtsensors = callPackage ./modules/qtsensors.nix { };
      qtserialbus = callPackage ./modules/qtserialbus.nix { };
      qtserialport = callPackage ./modules/qtserialport.nix { };
      qtshadertools = callPackage ./modules/qtshadertools.nix { };
      qtspeech = callPackage ./modules/qtspeech.nix { };
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
        inherit (darwin) autoSignDarwinBinariesHook bootstrap_cmds;
      };
      qtwebsockets = callPackage ./modules/qtwebsockets.nix { };
      qtwebview = callPackage ./modules/qtwebview.nix { };

      wrapQtAppsHook = callPackage
        ({ makeBinaryWrapper }: makeSetupHook
          {
            name = "wrap-qt6-apps-hook";
            propagatedBuildInputs = [ makeBinaryWrapper ];
          } ./hooks/wrap-qt-apps-hook.sh)
        { };

      qmake = callPackage
        ({ qtbase }: makeSetupHook
          {
            name = "qmake6-hook";
            propagatedBuildInputs = [ qtbase.dev ];
            substitutions = {
              fix_qmake_libtool = ./hooks/fix-qmake-libtool.sh;
            };
          } ./hooks/qmake-hook.sh)
        { };
    } // lib.optionalAttrs config.allowAliases {
      # Remove completely before 24.11
      overrideScope' = builtins.throw "qt6 now uses makeScopeWithSplicing which does not have \"overrideScope'\", use \"overrideScope\".";
    };

  baseScope = makeScopeWithSplicing' {
    otherSplices = generateSplicesForMkScope "qt6";
    f = addPackages;
  };

  bootstrapScope = baseScope.overrideScope (final: prev: {
    qtbase = prev.qtbase.override { qttranslations = null; };
    qtdeclarative = null;
  });

  finalScope = baseScope.overrideScope (final: prev: {
    qttranslations = bootstrapScope.qttranslations;
  });
in
finalScope
