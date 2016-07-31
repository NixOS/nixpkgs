/*

# Updates

1. Update the URL in `maintainers/scripts/generate-kde-frameworks.sh` and
   run that script from the top of the Nixpkgs tree.
2. Check that the new packages build correctly.
3. Commit the changes and open a pull request.

*/

{ pkgs, debug ? false }:

let

  inherit (pkgs) lib makeSetupHook stdenv;

  mirror = "mirror://kde";
  srcs = import ./srcs.nix { inherit (pkgs) fetchurl; inherit mirror; };

  packages = self: with self; {

    kdeDerivation = args:
      let
      in stdenv.mkDerivation (args // {

        outputs = args.outputs or [ "dev" "out" ];

        propagatedUserEnvPkgs =
          builtins.map lib.getBin (args.propagatedBuildInputs or []);

        cmakeFlags =
          (args.cmakeFlags or [])
          ++ [ "-DBUILD_TESTING=OFF" ]
          ++ lib.optional debug "-DCMAKE_BUILD_TYPE=Debug";

      });

    kdeFramework = args:
      let
        inherit (args) name;
        inherit (srcs."${name}") src version;
      in kdeDerivation (args // {
        name = "${name}-${version}";
        inherit src;

        meta = {
          license = with lib.licenses; [
            lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
          ];
          platforms = lib.platforms.linux;
          homepage = "http://www.kde.org";
        } // (args.meta or {});
      });

    kdeEnv = import ./kde-env.nix {
      inherit (pkgs) stdenv lib;
      inherit (pkgs.xorg) lndir;
    };

    kdeWrapper = import ./kde-wrapper.nix {
      inherit (pkgs) stdenv lib makeWrapper;
      inherit kdeEnv;
    };

    attica = callPackage ./attica.nix {};
    baloo = callPackage ./baloo.nix {};
    bluez-qt = callPackage ./bluez-qt.nix {};
    breeze-icons = callPackage ./breeze-icons.nix {};
    ecm =
      let drv = { cmake, ecmNoHooks, pkgconfig, qtbase, qttools }:
            makeSetupHook
            { deps = [ cmake ecmNoHooks pkgconfig qtbase qttools ]; }
            ./setup-hook.sh;
      in callPackage drv {};
    ecmNoHooks = callPackage ./extra-cmake-modules {
      inherit (srcs.extra-cmake-modules) src version;
    };
    frameworkintegration = callPackage ./frameworkintegration.nix {};
    kactivities = callPackage ./kactivities.nix {};
    kactivities-stats = callPackage ./kactivities-stats.nix {};
    kapidox = callPackage ./kapidox.nix {};
    karchive = callPackage ./karchive.nix {};
    kauth = callPackage ./kauth {};
    kbookmarks = callPackage ./kbookmarks.nix {};
    kcmutils = callPackage ./kcmutils {};
    kcodecs = callPackage ./kcodecs.nix {};
    kcompletion = callPackage ./kcompletion.nix {};
    kconfig = callPackage ./kconfig.nix {};
    kconfigwidgets = callPackage ./kconfigwidgets {};
    kcoreaddons = callPackage ./kcoreaddons.nix {};
    kcrash = callPackage ./kcrash.nix {};
    kdbusaddons = callPackage ./kdbusaddons.nix {};
    kdeclarative = callPackage ./kdeclarative.nix {};
    kded = callPackage ./kded.nix {};
    kdelibs4support = callPackage ./kdelibs4support {};
    kdesignerplugin = callPackage ./kdesignerplugin.nix {};
    kdesu = callPackage ./kdesu.nix {};
    kdnssd = callPackage ./kdnssd.nix {};
    kdoctools = callPackage ./kdoctools {};
    kemoticons = callPackage ./kemoticons.nix {};
    kfilemetadata = callPackage ./kfilemetadata {};
    kglobalaccel = callPackage ./kglobalaccel.nix {};
    kguiaddons = callPackage ./kguiaddons.nix {};
    khtml = callPackage ./khtml.nix {};
    ki18n = callPackage ./ki18n.nix {};
    kiconthemes = callPackage ./kiconthemes {};
    kidletime = callPackage ./kidletime.nix {};
    kimageformats = callPackage ./kimageformats.nix {};
    kinit = callPackage ./kinit {};
    kio = callPackage ./kio {};
    kitemmodels = callPackage ./kitemmodels.nix {};
    kitemviews = callPackage ./kitemviews.nix {};
    kjobwidgets = callPackage ./kjobwidgets.nix {};
    kjs = callPackage ./kjs.nix {};
    kjsembed = callPackage ./kjsembed.nix {};
    kmediaplayer = callPackage ./kmediaplayer.nix {};
    knewstuff = callPackage ./knewstuff.nix {};
    knotifications = callPackage ./knotifications.nix {};
    knotifyconfig = callPackage ./knotifyconfig.nix {};
    kpackage = callPackage ./kpackage {};
    kparts = callPackage ./kparts.nix {};
    kpeople = callPackage ./kpeople.nix {};
    kplotting = callPackage ./kplotting.nix {};
    kpty = callPackage ./kpty.nix {};
    kross = callPackage ./kross.nix {};
    krunner = callPackage ./krunner.nix {};
    kservice = callPackage ./kservice {};
    ktexteditor = callPackage ./ktexteditor.nix {};
    ktextwidgets = callPackage ./ktextwidgets.nix {};
    kunitconversion = callPackage ./kunitconversion.nix {};
    kwallet = callPackage ./kwallet.nix {};
    kwayland = callPackage ./kwayland.nix {};
    kwidgetsaddons = callPackage ./kwidgetsaddons.nix {};
    kwindowsystem = callPackage ./kwindowsystem.nix {};
    kxmlgui = callPackage ./kxmlgui.nix {};
    kxmlrpcclient = callPackage ./kxmlrpcclient.nix {};
    modemmanager-qt = callPackage ./modemmanager-qt.nix {};
    networkmanager-qt = callPackage ./networkmanager-qt.nix {};
    oxygen-icons5 = callPackage ./oxygen-icons5.nix {};
    plasma-framework = callPackage ./plasma-framework.nix {};
    solid = callPackage ./solid.nix {};
    sonnet = callPackage ./sonnet.nix {};
    threadweaver = callPackage ./threadweaver.nix {};
  };

in packages
