/*

# Updates

Before a major version update, make a copy of this directory. (We like to
keep the old version around for a short time after major updates.) Add a
top-level attribute to `top-level/all-packages.nix`.

1. Update the URL in `maintainers/scripts/generate-qt.sh`.
2. From the top of the Nixpkgs tree, run
   `./maintainers/scripts/generate-qt.sh > pkgs/development/libraries/qt-5/$VERSION/srcs.nix`.
3. Check that the new packages build correctly.
4. Commit the changes and open a pull request.

*/

{ pkgs

# options
, developerBuild ? false
, decryptSslTraffic ? false
}:

let inherit (pkgs) makeSetupHook makeWrapper stdenv; in

with stdenv.lib;

let

  mirror = "http://download.qt.io";
  srcs = import ./srcs.nix { inherit (pkgs) fetchurl; inherit mirror; };

  qtSubmodule = args:
    let
      inherit (args) name;
      version = args.version or srcs."${name}".version;
      src = args.src or srcs."${name}".src;
      inherit (pkgs.stdenv) mkDerivation;
    in mkDerivation (args // {
      name = "${name}-${version}";
      inherit src;

      propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or []);
      nativeBuildInputs =
        (args.nativeBuildInputs or [])
        ++ [ pkgs.perl self.qmakeHook ];

      NIX_QT_SUBMODULE = args.NIX_QT_SUBMODULE or true;

      outputs = args.outputs or [ "out" "dev" ];
      setOutputFlags = args.setOutputFlags or false;

      setupHook = ./setup-hook.sh;

      enableParallelBuilding = args.enableParallelBuilding or true;

      meta = self.qtbase.meta // (args.meta or {});
    });

  addPackages = self: with self;
    let
      callPackage = self.newScope { inherit qtSubmodule srcs; };
    in {

      qtbase = callPackage ./qtbase {
        inherit (srcs.qtbase) src version;
        mesa = pkgs.mesa_noglu;
        harfbuzz = pkgs.harfbuzz-icu;
        cups = if stdenv.isLinux then pkgs.cups else null;
        # GNOME dependencies are not used unless gtkStyle == true
        bison = pkgs.bison2; # error: too few arguments to function 'int yylex(...
        inherit developerBuild decryptSslTraffic;
      };

      qtconnectivity = callPackage ./qtconnectivity.nix {};
      qtdeclarative = callPackage ./qtdeclarative {};
      qtdoc = callPackage ./qtdoc.nix {};
      qtgraphicaleffects = callPackage ./qtgraphicaleffects.nix {};
      qtimageformats = callPackage ./qtimageformats.nix {};
      qtlocation = callPackage ./qtlocation.nix {};
      qtmultimedia = callPackage ./qtmultimedia.nix {
        inherit (pkgs.gst_all_1) gstreamer gst-plugins-base;
      };
      qtquickcontrols = callPackage ./qtquickcontrols.nix {};
      qtscript = callPackage ./qtscript {};
      qtsensors = callPackage ./qtsensors.nix {};
      qtserialport = callPackage ./qtserialport {};
      qtsvg = callPackage ./qtsvg.nix {};
      qttools = callPackage ./qttools {};
      qttranslations = callPackage ./qttranslations.nix {};
      qtwayland = callPackage ./qtwayland.nix {};
      qtwebchannel = callPackage ./qtwebchannel.nix {};
      qtwebengine = callPackage ./qtwebengine.nix {};
      qtwebkit = callPackage ./qtwebkit {};
      qtwebsockets = callPackage ./qtwebsockets.nix {};
      qtx11extras = callPackage ./qtx11extras.nix {};
      qtxmlpatterns = callPackage ./qtxmlpatterns.nix {};

      env = callPackage ../qt-env.nix {};
      full = env "qt-${qtbase.version}" [
        qtconnectivity qtdeclarative qtdoc qtgraphicaleffects
        qtimageformats qtlocation qtmultimedia qtquickcontrols qtscript
        qtsensors qtserialport qtsvg qttools qttranslations qtwayland
        qtwebsockets qtx11extras qtxmlpatterns
      ];

      makeQtWrapper =
        makeSetupHook
        { deps = [ makeWrapper ]; }
        ./make-qt-wrapper.sh;

      qmakeHook =
        makeSetupHook
        { deps = [ self.qtbase.dev ]; }
        ./qmake-hook.sh;

    };

   self = makeScope pkgs.newScope addPackages;

in self
