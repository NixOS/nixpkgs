/*

# Updates

Before a major version update, make a copy of this directory. (We like to
keep the old version around for a short time after major updates.) Add a
top-level attribute to `top-level/all-packages.nix`.

1. Update the URL in `pkgs/development/libraries/qt-5/$VERSION/fetch.sh`.
2. From the top of the Nixpkgs tree, run
   `./maintainers/scripts/fetch-kde-qt.sh > pkgs/development/libraries/qt-5/$VERSION/srcs.nix`.
3. Update `qtCompatVersion` below if the minor version number changes.
4. Check that the new packages build correctly.
5. Commit the changes and open a pull request.

*/

{
  newScope,
  stdenv, fetchurl, fetchFromGitHub, makeSetupHook,
  bison, cups ? null, harfbuzz, libGL, perl,
  gstreamer, gst-plugins-base, gtk3, dconf,
  cf-private,

  # options
  developerBuild ? false,
  decryptSslTraffic ? false,
  debug ? false,
}:

with stdenv.lib;

let

  qtCompatVersion = "5.11";

  mirror = "https://download.qt.io";
  srcs = import ./srcs.nix { inherit fetchurl; inherit mirror; } // {
    # Community port of the now unmaintained upstream qtwebkit.
    qtwebkit = {
      src = fetchFromGitHub {
        owner = "annulen";
        repo = "webkit";
        rev = "4ce8ebc4094512b9916bfa5984065e95ac97c9d8";
        sha256 = "05h1xnxzbf7sp3plw5dndsvpf6iigh0bi4vlj4svx0hkf1giakjf";
      };
      version = "5.212-alpha-01-26-2018";
    };
  };

  patches = {
    qtbase = [
      ./qtbase.patch
      ./qtbase-darwin.patch
      ./qtbase-revert-no-macos10.10.patch
      ./qtbase-fixguicmake.patch
    ] ++ optionals stdenv.isDarwin [
      ./qtbase-darwin-nseventtype.patch
    ];
    qtdeclarative = [ ./qtdeclarative.patch ];
    qtscript = [ ./qtscript.patch ];
    qtserialport = [ ./qtserialport.patch ];
    qttools = [ ./qttools.patch ];
    qtwebengine =
         optional stdenv.cc.isClang ./qtwebengine-clang-fix.patch
      ++ optional stdenv.isDarwin ./qtwebengine-darwin-sdk-10.10.patch;
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
        inherit (srcs.qtbase) src version;
        patches = patches.qtbase;
        inherit bison cups harfbuzz libGL;
        withGtk3 = true; inherit dconf gtk3;
        inherit developerBuild decryptSslTraffic;
      };

      qtcharts = callPackage ../modules/qtcharts.nix {};
      qtconnectivity = callPackage ../modules/qtconnectivity.nix {};
      qtdeclarative = callPackage ../modules/qtdeclarative.nix {};
      qtdoc = callPackage ../modules/qtdoc.nix {};
      qtgraphicaleffects = callPackage ../modules/qtgraphicaleffects.nix {};
      qtimageformats = callPackage ../modules/qtimageformats.nix {};
      qtlocation = callPackage ../modules/qtlocation.nix {};
      qtmacextras = callPackage ../modules/qtmacextras.nix {
        inherit cf-private;
      };
      qtmultimedia = callPackage ../modules/qtmultimedia.nix {
        inherit gstreamer gst-plugins-base;
      };
      qtquick1 = null;
      qtquickcontrols = callPackage ../modules/qtquickcontrols.nix {};
      qtquickcontrols2 = callPackage ../modules/qtquickcontrols2.nix {};
      qtscript = callPackage ../modules/qtscript.nix {};
      qtsensors = callPackage ../modules/qtsensors.nix {};
      qtserialport = callPackage ../modules/qtserialport.nix {};
      qtspeech = callPackage ../modules/qtspeech.nix {};
      qtsvg = callPackage ../modules/qtsvg.nix {};
      qttools = callPackage ../modules/qttools.nix {};
      qttranslations = callPackage ../modules/qttranslations.nix {};
      qtvirtualkeyboard = callPackage ../modules/qtvirtualkeyboard.nix {};
      qtwayland = callPackage ../modules/qtwayland.nix {};
      qtwebchannel = callPackage ../modules/qtwebchannel.nix {};
      qtwebengine = callPackage ../modules/qtwebengine.nix {};
      qtwebglplugin = callPackage ../modules/qtwebglplugin.nix {};
      qtwebkit = callPackage ../modules/qtwebkit.nix {};
      qtwebsockets = callPackage ../modules/qtwebsockets.nix {};
      qtx11extras = callPackage ../modules/qtx11extras.nix {};
      qtxmlpatterns = callPackage ../modules/qtxmlpatterns.nix {};

      env = callPackage ../qt-env.nix {};
      full = env "qt-full-${qtbase.version}" ([
        qtcharts qtconnectivity qtdeclarative qtdoc qtgraphicaleffects
        qtimageformats qtlocation qtmultimedia qtquickcontrols qtquickcontrols2
        qtscript qtsensors qtserialport qtsvg qttools qttranslations
        qtvirtualkeyboard qtwebchannel qtwebengine qtwebkit qtwebsockets
        qtx11extras qtxmlpatterns
      ] ++ optional (!stdenv.isDarwin) qtwayland
        ++ optional (stdenv.isDarwin) qtmacextras);

      qmake = makeSetupHook {
        deps = [ self.qtbase.dev ];
        substitutions = {
          inherit (stdenv) isDarwin;
          qtbase_dev = self.qtbase.dev;
          fix_qt_builtin_paths = ../hooks/fix-qt-builtin-paths.sh;
        };
      } ../hooks/qmake-hook.sh;
    };

   self = makeScope newScope addPackages;

in self
