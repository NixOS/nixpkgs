# Maintainer's Notes:
#
# Minor updates:
#  1. Edit ./fetchsrcs.sh to point to the updated URL.
#  2. Run ./fetchsrcs.sh.
#  3. Build and enjoy.
#
# Major updates:
#  We prefer not to immediately overwrite older versions with major updates, so
#  make a copy of this directory first. After copying, be sure to delete ./tmp
#  if it exists. Then follow the minor update instructions. Be sure to check if
#  any new components have been added and package them as necessary.

{ pkgs

# options
, developerBuild ? false
, decryptSslTraffic ? false
}:

let inherit (pkgs) makeSetupHook makeWrapper stdenv; in

with stdenv.lib;

let

  mirror = "http://download.qt.io";
  srcs = import ./srcs.nix { inherit mirror; inherit (pkgs) fetchurl; };

  qtSubmodule = args:
    let
      inherit (args) name;
      inherit (srcs."${args.name}") version src;
      inherit (pkgs.stdenv) mkDerivation;
    in mkDerivation (args // {
      name = "${name}-${version}";
      inherit src;

      propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or []);

      NIX_QT_SUBMODULE = args.NIX_QT_SUBMODULE or true;
      dontAddPrefix = args.dontAddPrefix or true;
      dontFixLibtool = args.dontFixLibtool or true;
      configureScript = args.configureScript or "qmake";

      enableParallelBuilding = args.enableParallelBuilding or true;

      meta = {
        homepage = http://qt-project.org;
        description = "A cross-platform application framework for C++";
        license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
        maintainers = with maintainers; [ bbenoist qknight ttuegel ];
        platforms = platforms.linux;
      } // (args.meta or {});
    });

  addPackages = self: with self;
    let
      callPackage = self.newScope { inherit qtSubmodule srcs; };
    in {

      qtbase = callPackage ./qtbase {
        mesa = pkgs.mesa_noglu;
        cups = if stdenv.isLinux then pkgs.cups else null;
        # GNOME dependencies are not used unless gtkStyle == true
        inherit (pkgs.gnome) libgnomeui GConf gnome_vfs;
        bison = pkgs.bison2; # error: too few arguments to function 'int yylex(...
        inherit developerBuild decryptSslTraffic;
      };

      /* qt3d = not packaged */
      /* qtactiveqt = not packaged */
      /* qtandroidextras = not packaged */
      /* qtcanvas3d = not packaged */
      qtconnectivity = callPackage ./qtconnectivity.nix {};
      qtdeclarative = callPackage ./qtdeclarative {};
      qtdoc = callPackage ./qtdoc.nix {};
      qtenginio = callPackage ./qtenginio.nix {};
      qtgraphicaleffects = callPackage ./qtgraphicaleffects.nix {};
      qtimageformats = callPackage ./qtimageformats.nix {};
      qtlocation = callPackage ./qtlocation.nix {};
      /* qtmacextras = not packaged */
      qtmultimedia = callPackage ./qtmultimedia.nix {
        inherit (pkgs.gst_all_1) gstreamer gst-plugins-base;
      };
      qtquick1 = callPackage ./qtquick1 {};
      qtquickcontrols = callPackage ./qtquickcontrols.nix {};
      qtscript = callPackage ./qtscript {};
      qtsensors = callPackage ./qtsensors.nix {};
      qtserialport = callPackage ./qtserialport {};
      qtsvg = callPackage ./qtsvg.nix {};
      qttools = callPackage ./qttools.nix {};
      qttranslations = callPackage ./qttranslations.nix {};
      /* qtwayland = not packaged */
      /* qtwebchannel = not packaged */
      /* qtwebengine = not packaged */
      qtwebkit = callPackage ./qtwebkit {};
      qtwebkit-examples = callPackage ./qtwebkit-examples.nix {};
      qtwebsockets = callPackage ./qtwebsockets.nix {};
      /* qtwinextras = not packaged */
      qtx11extras = callPackage ./qtx11extras.nix {};
      qtxmlpatterns = callPackage ./qtxmlpatterns.nix {};

      makeQtWrapper = makeSetupHook { deps = [ makeWrapper ]; } ./make-qt-wrapper.sh;

    };

in makeScope pkgs.newScope addPackages
