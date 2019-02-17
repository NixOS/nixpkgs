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
  stdenv, fetchurl, fetchpatch, makeSetupHook,
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
    qtbase = [
      ./qtbase.patch
      ./qtbase-fixguicmake.patch
      (fetchpatch {
        name = "CVE-2018-15518.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtbase.git;a=patch;h=28a6e642af2ccb454dd019f551c2908753f76f08";
        sha256 = "0nyssg7d0br7qgzp481f1w8b4p1bj2ggv9iyfrm1mng5v9fypdd7";
      })
      (fetchpatch {
        name = "CVE-2018-19873.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtbase.git;a=patch;h=c9b9f663d7243988bcb5fee9180ea9cb3a321a86";
        sha256 = "1q01cafy92c1j8cgrv4sk133mi3d48x8kbg3glbnnbijpc4k6di5";
      })
      (fetchpatch {
        name = "CVE-2018-19870.patch";
        url = "http://code.qt.io/cgit/qt/qtbase.git/patch/?id=ac0a910756f91726e03c0e6a89d213bdb4f48fec";
        sha256 = "00qb9yqwvwnp202am3lqirkjxln1cj8v4wvmlyqya6hna176lj2l";
      })
    ];
    qtdeclarative = [ ./qtdeclarative.patch ];
    qtscript = [ ./qtscript.patch ];
    qtserialport = [ ./qtserialport.patch ];
    qttools = [ ./qttools.patch ];
    qtwebengine = [ ./qtwebengine-seccomp.patch ];
    qtwebkit = [ ./qtwebkit.patch ];
    qtvirtualkeyboard = [
      (fetchpatch {
        name = "CVE-2018-19865-A.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtvirtualkeyboard.git;a=patch;h=c02115db1de1f3aba81e109043766d600f886522";
        sha256 = "0ncnyl8f3ypi1kcb9z2i8j33snix111h28njrx8rb49ny01ap8x2";
      })
      (fetchpatch {
        name = "CVE-2018-19865-B.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtvirtualkeyboard.git;a=patch;h=01fc537adc74d5e102c8cc93384cdf5cb08b4442";
        sha256 = "19z8kxqf2lpjqr8189ingrpadch4niviw3p5v93zgx24v7950q27";
      })
      (fetchpatch {
        name = "CVE-2018-19865-C.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtvirtualkeyboard.git;a=patch;h=993a21ba03534b172d5354405cc9d50a2a822e24";
        sha256 = "1bipqxr9bvy8z402pv9kj2w1yzcsj1v03l09pg5jyg1xh6jbgiky";
      })
    ];
    qtimageformats = [
      (fetchpatch {
        name = "CVE-2018-19871.patch";
        url = "https://codereview.qt-project.org/gitweb?p=qt/qtimageformats.git;a=patch;h=9299ab07df61c56b70e047f1fe5f06b6ff541aa3";
        sha256 = "0fd3mxdlc0s405j02bc0g72fvdfvpi31a837xfwf40m5j4jbyndr";
      })
    ];
    qtsvg = [
      (fetchpatch {
        name = "CVE-2018-19869.patch";
        url = "http://code.qt.io/cgit/qt/qtsvg.git/patch/?id=c5f1dd14098d1cc2cb52448fb44f53966d331443";
        sha256 = "1kgyfsxw2f0qv5fx9y7wysjsvqikam0qc7wzhklf0406zz6rhxbl";
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
      qtvirtualkeyboard = callPackage ../modules/qtvirtualkeyboard.nix {};

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
