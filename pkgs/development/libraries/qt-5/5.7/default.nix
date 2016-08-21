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

{ pkgs,
  darwin, fixDarwinDylibNames

# options
, developerBuild ? false
, decryptSslTraffic ? false
}:

let inherit (pkgs) makeSetupHook makeWrapper stdenv; in

with stdenv.lib;

let

  mirror = "https://download.qt.io";
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

      buildInputs = with stdenv; (args.buildInputs or [])
        ++ lib.optional isDarwin [ fixDarwinDylibNames ];

      propagatedBuildInputs = args.qtInputs ++ (args.propagatedBuildInputs or []);

      nativeBuildInputs =
        (args.nativeBuildInputs or [])
        ++ [ pkgs.perl self.qmakeHook ];

      NIX_QT_SUBMODULE = args.NIX_QT_SUBMODULE or true;

      outputs = args.outputs or [ "dev" "out" ];
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
        mesa = if stdenv.isLinux then pkgs.mesa_noglu else null;
        harfbuzz = if stdenv.isLinux then pkgs.harfbuzz-icu else pkgs.harfbuzz;
        cups = if stdenv.isLinux then pkgs.cups else null;
        inherit (darwin.apple_sdk.frameworks)
          CoreGraphics CoreServices CoreText Cocoa OpenGL AppKit Security
          SystemConfiguration CFNetwork DiskArbitration IOKit;
        inherit developerBuild decryptSslTraffic;
      };

      qtconnectivity = callPackage ./qtconnectivity.nix {};
      qtdeclarative = callPackage ./qtdeclarative {};
      qtdoc = callPackage ./qtdoc.nix {};
      qtgraphicaleffects = callPackage ./qtgraphicaleffects.nix {};
      qtimageformats = callPackage ./qtimageformats.nix {};
      qtlocation = callPackage ./qtlocation.nix {};
      qtmacextras = callPackage ./qtmacextras.nix {};
      qtmultimedia = callPackage ./qtmultimedia.nix {
        inherit (pkgs.gst_all_1)
          gstreamer gst-plugins-base;
        inherit (darwin.apple_sdk.frameworks)
          OpenAL AVFoundation CoreMedia QuartzCore AppKit Quartz
          AudioUnit AudioToolbox;
      };
      qtquickcontrols = callPackage ./qtquickcontrols.nix {};
      qtquickcontrols2 = callPackage ./qtquickcontrols2.nix {};
      qtscript = callPackage ./qtscript {};
      qtscxml = callPackage ./qtscxml.nix {};
      qtsensors = callPackage ./qtsensors.nix {};
      qtserialbus = callPackage ./qtserialbus.nix {};
      qtserialport = callPackage ./qtserialport {};
      qtsvg = callPackage ./qtsvg.nix {};
      qttools = callPackage ./qttools {};
      qttranslations = callPackage ./qttranslations.nix {};
      qtwebchannel = callPackage ./qtwebchannel.nix {};
      qtwebengine = callPackage ./qtwebengine.nix {};
      qtwebkit = callPackage ./qtwebkit {};
      qtwebsockets = callPackage ./qtwebsockets.nix {};
      qtx11extras = callPackage ./qtx11extras.nix {};
      qtxmlpatterns = callPackage ./qtxmlpatterns.nix {};

      env = callPackage ../qt-env.nix {};
      full = with stdenv; env "qt-${qtbase.version}" ([
        qtconnectivity qtdeclarative qtdoc qtgraphicaleffects
        qtimageformats qtlocation qtmultimedia qtquickcontrols qtquickcontrols2
        qtscript qtsensors qtscxml qtserialbus qtserialport qtsvg qttools qttranslations
        qtwebsockets qtxmlpatterns
      ]
      ++ lib.optional isDarwin [ qtmacextras ]
      ++ lib.optional isLinux [ qtx11extras ]);

      makeQtWrapper =
        makeSetupHook
        { deps = [ makeWrapper ]; }
        ./make-qt-wrapper.sh;

      qmakeHook =
        makeSetupHook
        { deps = [ self.qtbase ]; }
        ./qmake-hook.sh;

    };

   self = makeScope pkgs.newScope addPackages;

in self
