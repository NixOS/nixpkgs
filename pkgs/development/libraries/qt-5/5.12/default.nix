/*

# Updates

Before a major version update, make a copy of this directory. (We like to
keep the old version around for a short time after major updates.) Add a
top-level attribute to `top-level/all-packages.nix`.

1. Update the URL in `pkgs/development/libraries/qt-5/$VERSION/fetch.sh`.
2. From the top of the Nixpkgs tree, run
   `./maintainers/scripts/fetch-kde-qt.sh > pkgs/development/libraries/qt-5/$VERSION/srcs.nix`.
3. Check that the new packages build correctly.
4. Commit the changes and open a pull request.

*/

{
  newScope,
  stdenv, fetchurl, fetchpatch, fetchFromGitHub, makeSetupHook, makeWrapper,
  bison, cups ? null, harfbuzz, libGL, perl,
  gstreamer, gst-plugins-base, gtk3, dconf,
  llvmPackages_5,

  # options
  developerBuild ? false,
  decryptSslTraffic ? false,
  debug ? false,
}:

with stdenv.lib;

let

  qtCompatVersion = srcs.qtbase.version;

  stdenvActual = if stdenv.cc.isClang then llvmPackages_5.stdenv else stdenv;

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
      ./qtbase-fixguicmake.patch
      ./qtbase-trayicons.patch # can be removed with 5.12.4 or 5.13
      (fetchpatch {
        name = "CVE-2019-18281.patch";
        url = "https://github.com/qt/qtbase/commit/1232205e32464d90e871f39eb1e14fcf9b78a163.patch";
        sha256 = "1xfw3p94k7j8bly4rcfrlad2qaz7144q0fjmqsaib1c2927kcsfz";
      })
    ];
    qtdeclarative = [ ./qtdeclarative.patch ];
    qtscript = [ ./qtscript.patch ];
    qtserialport = [ ./qtserialport.patch ];
    qtwebengine = [
      ./qtwebengine-no-build-skip.patch
      # patch for CVE-2019-13720, can be removed when it is included in the next upstream release
      # https://bugreports.qt.io/browse/QTBUG-1019226
      (fetchpatch {
        name = "qtwebengine-CVE-2019-13720.patch";
        url = "https://code.qt.io/cgit/qt/qtwebengine-chromium.git/patch/?id=d6e5fc10";
        sha256 = "0ywc12m196pr6xn7l5xbascihygkjj4pbcgcn9wxvi5ssdr6z46z";
        extraPrefix = "src/3rdparty/";
        stripLen = 1;
      })
    ]
      ++ optional stdenv.isDarwin ./qtwebengine-darwin-no-platform-check.patch;
    qtwebkit = [ ./qtwebkit.patch ]
      ++ optionals stdenv.isDarwin [
        ./qtwebkit-darwin-no-readline.patch
        ./qtwebkit-darwin-no-qos-classes.patch
      ];
    qttools = [ ./qttools.patch ];
    qtwayland = [
      ./qtwayland-fix-webengine-freezeups-1.patch # can be removed with 5.12.4 or 5.13
      ./qtwayland-fix-webengine-freezeups-2.patch # can be removed with 5.12.4 or 5.13
    ];
  };

  qtModule =
    import ../qtModule.nix
    {
      inherit perl;
      inherit (stdenv) lib;
      # Use a variant of mkDerivation that does not include wrapQtApplications
      # to avoid cyclic dependencies between Qt modules.
      mkDerivation =
        import ../mkDerivation.nix
        { inherit (stdenv) lib; inherit debug; wrapQtAppsHook = null; }
        stdenvActual.mkDerivation;
    }
    { inherit self srcs patches; };

  addPackages = self: with self;
    let
      callPackage = self.newScope { inherit qtCompatVersion qtModule srcs; };
    in {

      mkDerivationWith =
        import ../mkDerivation.nix
        { inherit (stdenv) lib; inherit debug; inherit (self) wrapQtAppsHook; };

      mkDerivation = mkDerivationWith stdenvActual.mkDerivation;

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
      qtmacextras = callPackage ../modules/qtmacextras.nix {};
      qtmultimedia = callPackage ../modules/qtmultimedia.nix {
        inherit gstreamer gst-plugins-base;
      };
      qtnetworkauth = callPackage ../modules/qtnetworkauth.nix {};
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
      qtwebview = callPackage ../modules/qtwebview.nix {};
      qtx11extras = callPackage ../modules/qtx11extras.nix {};
      qtxmlpatterns = callPackage ../modules/qtxmlpatterns.nix {};

      env = callPackage ../qt-env.nix {};
      full = env "qt-full-${qtbase.version}" ([
        qtcharts qtconnectivity qtdeclarative qtdoc qtgraphicaleffects
        qtimageformats qtlocation qtmultimedia qtquickcontrols qtquickcontrols2
        qtscript qtsensors qtserialport qtsvg qttools qttranslations
        qtvirtualkeyboard qtwebchannel qtwebengine qtwebkit qtwebsockets
        qtwebview qtx11extras qtxmlpatterns
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

      wrapQtAppsHook = makeSetupHook {
        deps =
          [ self.qtbase.dev makeWrapper ]
          ++ optional stdenv.isLinux self.qtwayland.dev;
      } ../hooks/wrap-qt-apps-hook.sh;
    };

   self = makeScope newScope addPackages;

in self
