/*

# Updates

Before a major version update, make a copy of this directory. (We like to
keep the old version around for a short time after major updates.) Add a
top-level attribute to `top-level/all-packages.nix`.

1. Update the URL in `maintainers/scripts/generate-qt.sh`.
2. From the top of the Nixpkgs tree, run
   `./maintainers/scripts/generate-qt.sh > pkgs/development/libraries/qt-5/$VERSION/srcs.nix`.
3. Update `qtCompatVersion` below if the minor version number changes.
4. Check that the new packages build correctly.
5. Commit the changes and open a pull request.

*/

{
  newScope,
  stdenv, fetchurl, makeSetupHook, makeWrapper,
  bison, cups ? null, harfbuzz, mesa, perl,
  gstreamer, gst-plugins-base, gtk3, dconf,

  # options
  developerBuild ? false,
  decryptSslTraffic ? false,
  debug ? null,
}:

with stdenv.lib;

let

  qtCompatVersion = "5.9";

  mirror = "http://download.qt.io";
  srcs = import ./srcs.nix { inherit fetchurl; inherit mirror; };

  mkDerivation = args:
    stdenv.mkDerivation (args // {

      qmakeFlags =
        (args.qmakeFlags or [])
        ++ optional (debug != null)
           (if debug then "CONFIG+=debug" else "CONFIG+=release");

      cmakeFlags =
        (args.cmakeFlags or [])
        ++ [ "-DBUILD_TESTING=OFF" ]
        ++ optional (debug != null)
           (if debug then "-DCMAKE_BUILD_TYPE=Debug"
                     else "-DCMAKE_BUILD_TYPE=Release");

      enableParallelBuilding = args.enableParallelBuilding or true;

    });

  qtSubmodule = args:
    let
      inherit (args) name;
      version = args.version or srcs."${name}".version;
      src = args.src or srcs."${name}".src;
    in mkDerivation (args // {
      name = "${name}-${version}";
      inherit src;

      propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or []);
      nativeBuildInputs =
        (args.nativeBuildInputs or [])
        ++ [ perl self.qmake ];

      NIX_QT_SUBMODULE = args.NIX_QT_SUBMODULE or true;

      outputs = args.outputs or [ "out" "dev" ];
      setOutputFlags = args.setOutputFlags or false;

      setupHook = ../qtsubmodule-setup-hook.sh;

      meta = {
        homepage = http://www.qt.io;
        description = "A cross-platform application framework for C++";
        license = with licenses; [ fdl13 gpl2 lgpl21 lgpl3 ];
        maintainers = with maintainers; [ qknight ttuegel periklis ];
        platforms = platforms.unix;
      } // (args.meta or {});
    });

  addPackages = self: with self;
    let
      callPackage = self.newScope { inherit qtCompatVersion qtSubmodule srcs; };
    in {

      inherit mkDerivation;

      qtbase = callPackage ./qtbase {
        inherit (srcs.qtbase) src version;
        inherit bison cups harfbuzz mesa;
        inherit dconf gtk3;
        inherit developerBuild decryptSslTraffic;
      };

      qtcharts = callPackage ./qtcharts.nix {};
      qtconnectivity = callPackage ./qtconnectivity.nix {};
      qtdeclarative = callPackage ./qtdeclarative {};
      qtdoc = callPackage ./qtdoc.nix {};
      qtgraphicaleffects = callPackage ./qtgraphicaleffects.nix {};
      qtimageformats = callPackage ./qtimageformats.nix {};
      qtlocation = callPackage ./qtlocation.nix {};
      qtmacextras = callPackage ./qtmacextras.nix {};
      qtmultimedia = callPackage ./qtmultimedia.nix {
        inherit gstreamer gst-plugins-base;
      };
      qtquick1 = null;
      qtquickcontrols = callPackage ./qtquickcontrols.nix {};
      qtquickcontrols2 = callPackage ./qtquickcontrols2.nix {};
      qtscript = callPackage ./qtscript {};
      qtsensors = callPackage ./qtsensors.nix {};
      qtserialport = callPackage ./qtserialport {};
      qtsvg = callPackage ./qtsvg.nix {};
      qttools = callPackage ./qttools {};
      qttranslations = callPackage ./qttranslations.nix {};
      qtwayland = callPackage ./qtwayland.nix {};
      qtwebchannel = callPackage ./qtwebchannel.nix {};
      qtwebengine = callPackage ./qtwebengine {};
      qtwebkit = callPackage ./qtwebkit {};
      qtwebsockets = callPackage ./qtwebsockets.nix {};
      qtx11extras = callPackage ./qtx11extras.nix {};
      qtxmlpatterns = callPackage ./qtxmlpatterns.nix {};

      env = callPackage ../qt-env.nix {};
      full = env "qt-${qtbase.version}" ([
        qtcharts qtconnectivity qtdeclarative qtdoc qtgraphicaleffects
        qtimageformats qtlocation qtmultimedia qtquickcontrols qtscript
        qtsensors qtserialport qtsvg qttools qttranslations qtwebsockets
        qtx11extras qtxmlpatterns
      ] ++ optional (!stdenv.isDarwin) qtwayland
        ++ optional (stdenv.isDarwin) qtmacextras);

      qmake = makeSetupHook {
        deps = [ self.qtbase.dev ];
        substitutions = { inherit (stdenv) isDarwin; };
      } ../qmake-hook.sh;
    };

   self = makeScope newScope addPackages;

in self
