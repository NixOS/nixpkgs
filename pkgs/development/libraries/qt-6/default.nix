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
, gtk3
, dconf
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
      callPackage = self.newScope { inherit qtModule srcs; };
    in
    {

      inherit callPackage qtModule srcs;

      qtbase = callPackage ./modules/qtbase.nix {
        withGtk3 = true;
        inherit (srcs.qtbase) src version;
        inherit bison cups harfbuzz libGL dconf gtk3 developerBuild cmake;
      };

      qt3d = callPackage ./modules/qt3d.nix { };
      qt5compat = callPackage ./modules/qt5compat.nix { };
      qtcharts = callPackage ./modules/qtcharts.nix { };
      qtconnectivity = callPackage ./modules/qtconnectivity.nix { };
      qtdatavis3d = callPackage ./modules/qtdatavis3d.nix { };
      qtdeclarative = callPackage ./modules/qtdeclarative.nix { };
      qtdoc = callPackage ./modules/qtdoc.nix { };
      qtimageformats = callPackage ./modules/qtimageformats.nix { };
      qtlanguageserver = callPackage ./modules/qtlanguageserver.nix { };
      qtlottie = callPackage ./modules/qtlottie.nix { };
      qtmultimedia = callPackage ./modules/qtmultimedia.nix {
        inherit gstreamer gst-plugins-base;
      };
      qtnetworkauth = callPackage ./modules/qtnetworkauth.nix { };
      qtpositioning = callPackage ./modules/qtpositioning.nix { };
      qtsensors = callPackage ./modules/qtsensors.nix { };
      qtserialbus = callPackage ./modules/qtserialbus.nix { };
      qtserialport = callPackage ./modules/qtserialport.nix { };
      qtshadertools = callPackage ./modules/qtshadertools.nix { };
      qtquick3d = callPackage ./modules/qtquick3d.nix { };
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
      qtwebview = callPackage ./modules/qtwebview.nix { };

      wrapQtAppsHook = makeSetupHook {
          deps = [ buildPackages.makeWrapper ];
        } ./hooks/wrap-qt-apps-hook.sh;
    };

  self = lib.makeScope newScope addPackages;
in
self
