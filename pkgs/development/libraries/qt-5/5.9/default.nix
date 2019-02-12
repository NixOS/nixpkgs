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
  stdenv, fetchurl, fetchpatch, makeSetupHook,
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

  qtCompatVersion = "5.9";

  mirror = "http://download.qt.io";
  srcs = import ./srcs.nix { inherit fetchurl; inherit mirror; };

  patches = {
    qtbase = [ ./qtbase.patch ./qtbase-fixguicmake.patch ] ++ optional stdenv.isDarwin ./qtbase-darwin.patch;
    qtdeclarative = [ ./qtdeclarative.patch ];
    qtscript = [ ./qtscript.patch ];
    qtserialport = [ ./qtserialport.patch ];
    qttools = [ ./qttools.patch ];
    qtwebkit = [ ./qtwebkit.patch ];
    qtvirtualkeyboard = [
      (fetchpatch {
        name = "CVE-2018-19865-A.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtvirtualkeyboard.git;a=patch;h=61780a113f02b3c62fb14516fe8ea47d91f9ed9a";
        sha256 = "0jd4nzaz9ndm9ryvrkav7kjs437l661288diklhbmgh249f8gki0";
      })
      (fetchpatch {
        name = "CVE-2018-19865-B.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtvirtualkeyboard.git;a=patch;h=c0ac7a4c684e2fed60a72ceee53da89eea3f95a7";
        sha256 = "0yvxrx5vx6845vgnq8ml3q93y61py5j0bvhqj7nqvpbmyj1wy1p3";

      })
      (fetchpatch {
        name = "CVE-2018-19865-C.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtvirtualkeyboard.git;a=patch;h=a2e7b8412f56841e12ed20a39f4a38e32d3c1e30";
        sha256 = "1yijysa9gy5xbxndx5ri0dkfrjqja0d1bsx52qz4mhzi4pkbib02";
      })
    ];

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
      qtsvg = callPackage ../modules/qtsvg.nix {};
      qttools = callPackage ../modules/qttools.nix {};
      qttranslations = callPackage ../modules/qttranslations.nix {};
      qtvirtualkeyboard = callPackage ../modules/qtvirtualkeyboard.nix {};
      qtwayland = callPackage ../modules/qtwayland.nix {};
      qtwebchannel = callPackage ../modules/qtwebchannel.nix {};
      qtwebengine = callPackage ../modules/qtwebengine.nix {};
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
