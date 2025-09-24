/*
  # New packages

  READ THIS FIRST

  This module is for official packages in KDE Frameworks 5. All available packages
  are listed in `./srcs.nix`, although a few are not yet packaged in Nixpkgs (see
  below).

  IF YOUR PACKAGE IS NOT LISTED IN `./srcs.nix`, IT DOES NOT GO HERE.

  Many of the packages released upstream are not yet built in Nixpkgs due to lack
  of demand. To add a Nixpkgs build for an upstream package, copy one of the
  existing packages here and modify it as necessary.

  # Updates

  1. Update the URL in `./fetch.sh`.
  2. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/development/libraries/kde-frameworks`
     from the top of the Nixpkgs tree.
  3. Use `nox-review wip` to check that everything builds.
  4. Commit the changes and open a pull request.
*/

{
  config,
  libsForQt5,
  lib,
  fetchurl,
}:

let
  maintainers = with lib.maintainers; [
    ttuegel
    nyanloutre
  ];
  license = with lib.licenses; [
    lgpl21Plus
    lgpl3Plus
    bsd2
    mit
    gpl2Plus
    gpl3Plus
    fdl12Plus
  ];

  srcs = import ./srcs.nix {
    inherit fetchurl;
    mirror = "mirror://kde";
  };

  mkDerivation = libsForQt5.callPackage (
    {
      stdenv,
      mkDerivation ? stdenv.mkDerivation,
    }:
    mkDerivation
  ) { };

  packages =
    self:
    with self;
    # SUPPORT
    let

      propagate =
        out:
        let
          setupHook =
            { writeScript }:
            writeScript "setup-hook" ''
              if [ "''${hookName:-}" != postHook ]; then
                  postHooks+=("source @dev@/nix-support/setup-hook")
              else
                  # Propagate $dev so that this setup hook is propagated
                  # But only if there is a separate $dev output
                  if [ "''${outputDev:?}" != out ]; then
                      appendToVar propagatedBuildInputs "@dev@"
                  fi
              fi
            '';
        in
        callPackage setupHook { };

      propagateBin = propagate "bin";

      callPackage = self.newScope {

        inherit propagate propagateBin;

        mkDerivation =
          args:
          let

            inherit (args) pname;
            inherit (srcs.${pname}) src version;

            outputs =
              args.outputs or [
                "bin"
                "dev"
                "out"
              ];
            hasSeparateDev = lib.elem "dev" outputs;

            defaultSetupHook = if hasSeparateDev then propagateBin else null;
            setupHook = args.setupHook or defaultSetupHook;

            meta =
              let
                meta = args.meta or { };
              in
              meta
              // {
                homepage = meta.homepage or "https://kde.org";
                license = meta.license or license;
                maintainers = (meta.maintainers or [ ]) ++ maintainers;
                platforms = meta.platforms or lib.platforms.all;
              };

          in
          mkDerivation (
            args
            // {
              inherit
                pname
                meta
                outputs
                setupHook
                src
                version
                ;
            }
          );

      };

      mkThrow =
        name: throw "libsForQt5.${name} has been removed, as KDE Frameworks 5 has reached end of life.";
    in
    (
      {
        extra-cmake-modules = callPackage ./extra-cmake-modules { };

        # TIER 1
        attica = callPackage ./attica.nix { };
        breeze-icons = callPackage ./breeze-icons.nix { };
        karchive = callPackage ./karchive.nix { };
        kcalendarcore = callPackage ./kcalendarcore.nix { };
        kcodecs = callPackage ./kcodecs.nix { };
        kconfig = callPackage ./kconfig.nix { };
        kcoreaddons = callPackage ./kcoreaddons.nix { };
        kdbusaddons = callPackage ./kdbusaddons.nix { };
        kdnssd = callPackage ./kdnssd.nix { };
        kguiaddons = callPackage ./kguiaddons.nix { };
        ki18n = callPackage ./ki18n.nix { };
        kidletime = callPackage ./kidletime.nix { };
        kirigami2 = callPackage ./kirigami2.nix { };
        kitemmodels = callPackage ./kitemmodels.nix { };
        kitemviews = callPackage ./kitemviews.nix { };
        kplotting = callPackage ./kplotting.nix { };
        kwayland = callPackage ./kwayland.nix { };
        kwidgetsaddons = callPackage ./kwidgetsaddons.nix { };
        kwindowsystem = callPackage ./kwindowsystem { };
        solid = callPackage ./solid { };
        sonnet = callPackage ./sonnet.nix { };
        syntax-highlighting = callPackage ./syntax-highlighting.nix { };

        # TIER 2
        kactivities = callPackage ./kactivities.nix { };
        kauth = callPackage ./kauth { };
        kcompletion = callPackage ./kcompletion.nix { };
        kcrash = callPackage ./kcrash.nix { };
        kdoctools = callPackage ./kdoctools { };
        kjobwidgets = callPackage ./kjobwidgets.nix { };
        knotifications = callPackage ./knotifications.nix { };
        kpackage = callPackage ./kpackage { };
        kunitconversion = callPackage ./kunitconversion.nix { };
        syndication = callPackage ./syndication.nix { };

        # TIER 3
        kactivities-stats = callPackage ./kactivities-stats.nix { };
        kbookmarks = callPackage ./kbookmarks.nix { };
        kcmutils = callPackage ./kcmutils.nix { };
        kconfigwidgets = callPackage ./kconfigwidgets.nix { };
        kdeclarative = callPackage ./kdeclarative.nix { };
        kded = callPackage ./kded.nix { };
        kemoticons = callPackage ./kemoticons.nix { };
        kglobalaccel = callPackage ./kglobalaccel.nix { };
        kiconthemes = callPackage ./kiconthemes { };
        kinit = callPackage ./kinit { };
        kio = callPackage ./kio { };
        knewstuff = callPackage ./knewstuff { };
        knotifyconfig = callPackage ./knotifyconfig.nix { };
        kparts = callPackage ./kparts.nix { };
        kservice = callPackage ./kservice { };
        ktextwidgets = callPackage ./ktextwidgets.nix { };
        kwallet = callPackage ./kwallet.nix { };
        kxmlgui = callPackage ./kxmlgui.nix { };
        plasma-framework = callPackage ./plasma-framework.nix { };

        # TIER 4
        frameworkintegration = callPackage ./frameworkintegration.nix { };

        # PORTING AIDS
        kdelibs4support = callPackage ./kdelibs4support { };
        kdesignerplugin = callPackage ./kdesignerplugin.nix { };
      }
      // lib.optionalAttrs config.allowAliases {
        baloo = mkThrow "baloo";
        bluez-qt = mkThrow "bluez-qt";
        kapidox = mkThrow "kapidox";
        kcontacts = mkThrow "kcontacts";
        kdav = mkThrow "kdav";
        kdesu = mkThrow "kdesu";
        kfilemetadata = mkThrow "kfilemetadata";
        kholidays = mkThrow "kholidays";
        khtml = mkThrow "kthml";
        kimageformats = mkThrow "kimageformats";
        kjs = mkThrow "kjs";
        kjsembed = mkThrow "kjsembed";
        kmediaplayer = mkThrow "kmediaplayer";
        kpeople = mkThrow "kpeople";
        kpty = mkThrow "kpty";
        kpurpose = mkThrow "kpurpose";
        kquickcharts = mkThrow "kquickcharts";
        kross = mkThrow "kross";
        krunner = mkThrow "krunner";
        ktexteditor = mkThrow "ktexteditor";
        kxmlrpcclient = mkThrow "kxmlrpcclient";
        modemmanager-qt = mkThrow "modemmanager-qt";
        networkmanager-qt = mkThrow "networkmanager-qt";
        oxygen-icons = mkThrow "oxygen-icons";
        oxygen-icons5 = mkThrow "oxygen-icons";
        prison = mkThrow "prison";
        qqc2-desktop-style = mkThrow "qqc2-desktop-style";
        threadweaver = mkThrow "threadweaver";
      }
    );

in
lib.makeScope libsForQt5.newScope packages
