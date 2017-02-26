/*

# Minor Updates

1. Edit ./fetchsrcs.sh to point to the updated URL.
2. Run ./fetchsrcs.sh.
3. Build and enjoy.

# Major Updates

1. Make a copy of this directory. (We like to keep the old version around
   for a short time after major updates.)
2. Delete the tmp/ subdirectory of the copy.
3. Follow the minor update instructions above.
4. Package any new Qt modules, if necessary.

*/

{
  newScope,
  stdenv, fetchurl, makeSetupHook, makeWrapper,
  bison, cups ? null, harfbuzz, mesa, perl,
  libgnomeui, GConf, gnome_vfs,
  gstreamer, gst-plugins-base,

  # options
  developerBuild ? false,
  decryptSslTraffic ? false,
}:

with stdenv.lib;

let

  mirror = "http://download.qt.io";
  srcs = import ./srcs.nix { inherit mirror; inherit fetchurl; };

  qtSubmodule = args:
    let
      inherit (args) name;
      inherit (srcs."${args.name}") version src;
      inherit (stdenv) mkDerivation;
    in mkDerivation (args // {
      name = "${name}-${version}";
      inherit src;

      propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or []);
      nativeBuildInputs = (args.nativeBuildInputs or []) ++ [ self.qmakeHook ];

      NIX_QT_SUBMODULE = args.NIX_QT_SUBMODULE or true;

      outputs = args.outputs or [ "out" "dev" ];
      setOutputFlags = args.setOutputFlags or false;

      setupHook = ../qtsubmodule-setup-hook.sh;

      enableParallelBuilding = args.enableParallelBuilding or true;

      meta = self.qtbase.meta // (args.meta or {});
    });

  addPackages = self: with self;
    let
      callPackage = self.newScope { inherit qtSubmodule srcs; };
    in {

      qtbase = callPackage ./qtbase {
        inherit bison cups harfbuzz mesa;
        # GNOME dependencies are not used unless gtkStyle == true
        inherit libgnomeui GConf gnome_vfs;
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
        inherit gstreamer gst-plugins-base;
      };
      qtquick1 = callPackage ./qtquick1 {};
      qtquickcontrols = callPackage ./qtquickcontrols.nix {};
      qtquickcontrols2 = null;
      qtscript = callPackage ./qtscript {};
      qtsensors = callPackage ./qtsensors.nix {};
      qtserialport = callPackage ./qtserialport {};
      qtsvg = callPackage ./qtsvg.nix {};
      qttools = callPackage ./qttools {};
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

      env = callPackage ../qt-env.nix {};
      full = env "qt-${qtbase.version}" [
        qtconnectivity qtdeclarative qtdoc qtenginio qtgraphicaleffects qtimageformats
        qtlocation qtmultimedia qtquick1 qtquickcontrols qtscript qtsensors qtserialport
        qtsvg qttools qttranslations qtwebkit qtwebkit-examples qtwebsockets qtx11extras
        qtxmlpatterns
      ];

      makeQtWrapper =
        makeSetupHook
        { deps = [ makeWrapper ]; }
        ../make-qt-wrapper.sh;

      qmakeHook =
        makeSetupHook
        { deps = [ self.qtbase.dev ]; }
        ../qmake-hook.sh;

    };

   self = makeScope newScope addPackages;

in self
