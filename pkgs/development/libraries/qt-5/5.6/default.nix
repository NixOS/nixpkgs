/*

# New packages

READ THIS FIRST

This module is for official packages in Qt 5. All available packages are listed
in `./srcs.nix`, although a few are not yet packaged in Nixpkgs (see below).

IF YOUR PACKAGE IS NOT LISTED IN `./srcs.nix`, IT DOES NOT GO HERE.

Many of the packages released upstream are not yet built in Nixpkgs due to lack
of demand. To add a Nixpkgs build for an upstream package, copy one of the
existing packages here and modify it as necessary.

# Updates

1. Update the URL in `./fetch.sh`.
2. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/qt-5/$VERSION/`
   from the top of the Nixpkgs tree.
3. Update `qtCompatVersion` below if the minor version number changes.
4. Check that the new packages build correctly.
5. Commit the changes and open a pull request.

*/

{
  newScope,
  stdenv, fetchurl, makeSetupHook, makeWrapper,
  bison, cups ? null, harfbuzz, libGL, perl,
  gstreamer, gst-plugins-base,

  # options
  developerBuild ? false,
  decryptSslTraffic ? false,
  debug ? false,
}:

with stdenv.lib;

let

  qtCompatVersion = "5.6";

  mirror = "http://download.qt.io";
  srcs = import ./srcs.nix { inherit fetchurl; inherit mirror; };

  patches = {
    qtbase = [ ./qtbase.patch ];
    qtdeclarative = [ ./qtdeclarative.patch ];
    qtscript = [ ./qtscript.patch ];
    qtserialport = [ ./qtserialport.patch ];
    qttools = [ ./qttools.patch ];
    qtwebengine = [ ./qtwebengine-seccomp.patch ]
      ++ optional stdenv.needsPax ./qtwebengine-paxmark-mksnapshot.patch;
    qtwebkit = [ ./qtwebkit.patch ];
  };

  mkDerivation =
    import ../mkDerivation.nix
    { inherit stdenv; inherit (stdenv) lib; }
    { inherit debug; };

  qtModule =
    import ../qtModule.nix
    { inherit mkDerivation perl; inherit (stdenv) lib; }
    { inherit self srcs patches; };

  addPackages = self: with self;
    let
      callPackage = self.newScope { inherit qtCompatVersion qtModule srcs; };
    in {

      inherit mkDerivation;

      qtbase = callPackage ../modules/qtbase.nix {
        inherit bison cups harfbuzz libGL;
        inherit (srcs.qtbase) src version;
        patches = patches.qtbase;
        inherit developerBuild decryptSslTraffic;
      };

      /* qt3d = not packaged */
      /* qtactiveqt = not packaged */
      /* qtandroidextras = not packaged */
      /* qtcanvas3d = not packaged */
      qtconnectivity = callPackage ../modules/qtconnectivity.nix {};
      qtdeclarative = callPackage ../modules/qtdeclarative.nix {};
      qtdoc = callPackage ../modules/qtdoc.nix {};
      qtgraphicaleffects = callPackage ../modules/qtgraphicaleffects.nix {};
      qtimageformats = callPackage ../modules/qtimageformats.nix {};
      qtlocation = callPackage ../modules/qtlocation.nix {};
      /* qtmacextras = not packaged */
      qtmultimedia = callPackage ../modules/qtmultimedia.nix {
        inherit gstreamer gst-plugins-base;
      };
      qtquick1 = null;
      qtquickcontrols = callPackage ../modules/qtquickcontrols.nix {};
      qtquickcontrols2 = callPackage ../modules/qtquickcontrols2.nix {};
      qtscript = callPackage ../modules/qtscript.nix {};
      qtsensors = callPackage ../modules/qtsensors.nix {};
      qtserialport = callPackage ../modules/qtserialport.nix {};
      qtsvg = callPackage ../modules/qtsvg.nix {};
      qttools = callPackage ../modules/qttools.nix {};
      qttranslations = callPackage ../modules/qttranslations.nix {};
      qtwayland = callPackage ../modules/qtwayland.nix {};
      qtwebchannel = callPackage ../modules/qtwebchannel.nix {};
      qtwebengine = callPackage ../modules/qtwebengine.nix {};
      qtwebkit = callPackage ../modules/qtwebkit.nix {};
      qtwebsockets = callPackage ../modules/qtwebsockets.nix {};
      /* qtwinextras = not packaged */
      qtx11extras = callPackage ../modules/qtx11extras.nix {};
      qtxmlpatterns = callPackage ../modules/qtxmlpatterns.nix {};

      env = callPackage ../qt-env.nix {};
      full = env "qt-full-${qtbase.version}" [
        qtconnectivity qtdeclarative qtdoc qtgraphicaleffects qtimageformats
        qtlocation qtmultimedia qtquickcontrols qtquickcontrols2 qtscript
        qtsensors qtserialport qtsvg qttools qttranslations qtwayland
        qtwebchannel qtwebengine qtwebkit qtwebsockets qtx11extras qtxmlpatterns
      ];

      qmake = makeSetupHook {
        deps = [ self.qtbase.dev ];
        substitutions = { inherit (stdenv) isDarwin; };
      } ../hooks/qmake-hook.sh;
    };

   self = makeScope newScope addPackages;

in self
