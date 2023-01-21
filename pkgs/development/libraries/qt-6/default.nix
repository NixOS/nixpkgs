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
, ninja
, writeText
, gstreamer
, gst-plugins-base
, gst-plugins-good
, gst-libav
, gst-vaapi
, gtk3
, dconf
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

  qtModule =
    import ./qtModule.nix
      { inherit stdenv lib perl cmake ninja writeText; }
      { inherit self srcs; };

  addPackages = self: with self;
    let
      callPackage = self.newScope ({ inherit qtModule stdenv srcs; });
    in
    {

      inherit callPackage qtModule srcs;

      qtbase = callPackage ./modules/qtbase.nix {
        withGtk3 = true;
        inherit (srcs.qtbase) src version;
        inherit bison cups harfbuzz libGL dconf gtk3 developerBuild cmake;
        inherit (darwin.apple_sdk_11_0.frameworks) AGL AVFoundation AppKit GSS MetalKit;
        patches = [
          ./patches/qtbase-qmake-mkspecs-mac.patch
          ./patches/qtbase-qmake-pkg-config.patch
          ./patches/qtbase-tzdir.patch
          # Remove symlink check causing build to bail out and fail.
          # https://gitlab.kitware.com/cmake/cmake/-/issues/23251
          (fetchpatch {
            url = "https://github.com/Homebrew/formula-patches/raw/c363f0edf9e90598d54bc3f4f1bacf95abbda282/qt/qt_internal_check_if_path_has_symlinks.patch";
            sha256 = "sha256-Gv2L8ymZSbJxcmUijKlT2NnkIB3bVH9D7YSsDX2noTU=";
          })
        ];
      };
      env = callPackage ./qt-env.nix {};
      full = env "qt-full-${qtbase.version}" ([
        qt3d
        qt5compat
        qtcharts
        qtconnectivity
        qtdeclarative
        qtdoc
        qtimageformats
        qtlottie
        qtmultimedia
        qtnetworkauth
        qtpositioning
        qtsensors
        qtserialbus
        qtserialport
        qtshadertools
        qtquick3d
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
        inherit (darwin.apple_sdk_11_0.frameworks) PCSC;
      };
      qtdatavis3d = callPackage ./modules/qtdatavis3d.nix { };
      qtdeclarative = callPackage ./modules/qtdeclarative.nix { };
      qtdoc = callPackage ./modules/qtdoc.nix { };
      qthttpserver = callPackage ./modules/qthttpserver.nix { };
      qtimageformats = callPackage ./modules/qtimageformats.nix { };
      qtlanguageserver = callPackage ./modules/qtlanguageserver.nix { };
      qtlottie = callPackage ./modules/qtlottie.nix { };
      qtmultimedia = callPackage ./modules/qtmultimedia.nix {
        inherit gstreamer gst-plugins-base gst-plugins-good gst-libav gst-vaapi;
        inherit (darwin.apple_sdk_11_0.frameworks) VideoToolbox;
      };
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
      qtquicktimeline = callPackage ./modules/qtquicktimeline.nix { };
      qtremoteobjects = callPackage ./modules/qtremoteobjects.nix { };
      qtsvg = callPackage ./modules/qtsvg.nix { };
      qtscxml = callPackage ./modules/qtscxml.nix { };
      qttools = callPackage ./modules/qttools.nix { };
      qttranslations = callPackage ./modules/qttranslations.nix { };
      qtvirtualkeyboard = callPackage ./modules/qtvirtualkeyboard.nix { };
      qtwayland = callPackage ./modules/qtwayland.nix { };
      qtwebchannel = callPackage ./modules/qtwebchannel.nix { };
      qtwebengine = callPackage ./modules/qtwebengine.nix { };
      qtwebsockets = callPackage ./modules/qtwebsockets.nix { };
      qtwebview = callPackage ./modules/qtwebview.nix {
        inherit (darwin.apple_sdk_11_0.frameworks) WebKit;
      };

      wrapQtAppsHook = makeSetupHook {
        name = "wrap-qt6-apps-hook";
          deps = [ buildPackages.makeWrapper ];
        } ./hooks/wrap-qt-apps-hook.sh;

      qmake = makeSetupHook {
        name = "qmake6-hook";
        deps = [ self.qtbase.dev ];
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
