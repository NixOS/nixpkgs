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

{ libsForQt5, lib, fetchurl }:

let
  maintainers = with lib.maintainers; [ ttuegel nyanloutre ];
  license = with lib.licenses; [
    lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12Plus
  ];

  srcs = import ./srcs.nix {
    inherit fetchurl;
    mirror = "mirror://kde";
  };

  mkDerivation = libsForQt5.callPackage ({ stdenv, mkDerivation ? stdenv.mkDerivation }: mkDerivation) {};

  packages = self: with self;
    # SUPPORT
    let

      propagate = out:
        let setupHook = { writeScript }:
              writeScript "setup-hook" ''
                if [ "''${hookName:-}" != postHook ]; then
                    postHooks+=("source @dev@/nix-support/setup-hook")
                else
                    # Propagate $dev so that this setup hook is propagated
                    # But only if there is a separate $dev output
                    if [ "''${outputDev:?}" != out ]; then
                        propagatedBuildInputs="''${propagatedBuildInputs-} @dev@"
                    fi
                fi
              '';
        in callPackage setupHook {};

      propagateBin = propagate "bin";

      callPackage = self.newScope {

        inherit propagate propagateBin;

        mkDerivation = args:
          let

            inherit (args) pname;
            inherit (srcs.${pname}) src version;

            outputs = args.outputs or [ "bin" "dev" "out" ];
            hasSeparateDev = lib.elem "dev" outputs;

            defaultSetupHook = if hasSeparateDev then propagateBin else null;
            setupHook = args.setupHook or defaultSetupHook;

            meta =
              let meta = args.meta or {}; in
              meta // {
                homepage = meta.homepage or "https://kde.org";
                license = meta.license or license;
                maintainers = (meta.maintainers or []) ++ maintainers;
                platforms = meta.platforms or lib.platforms.linux;
              };

          in mkDerivation (args // {
            inherit pname meta outputs setupHook src version;
          });

      };

    in {
      extra-cmake-modules = callPackage ./extra-cmake-modules {};

    # TIER 1
      attica = callPackage ./attica.nix {};
      bluez-qt = callPackage ./bluez-qt.nix {};
      breeze-icons = callPackage ./breeze-icons.nix {};
      kapidox = callPackage ./kapidox.nix {};
      karchive = callPackage ./karchive.nix {};
      kcalendarcore = callPackage ./kcalendarcore.nix {};
      kcodecs = callPackage ./kcodecs.nix {};
      kconfig = callPackage ./kconfig.nix {};
      kcoreaddons = callPackage ./kcoreaddons.nix {};
      kdbusaddons = callPackage ./kdbusaddons.nix {};
      kdnssd = callPackage ./kdnssd.nix {};
      kguiaddons = callPackage ./kguiaddons.nix {};
      kholidays = callPackage ./kholidays.nix {};
      ki18n = callPackage ./ki18n.nix {};
      kidletime = callPackage ./kidletime.nix {};
      kirigami2 = callPackage ./kirigami2.nix {};
      kitemmodels = callPackage ./kitemmodels.nix {};
      kitemviews = callPackage ./kitemviews.nix {};
      kplotting = callPackage ./kplotting.nix {};
      kquickcharts = callPackage ./kquickcharts.nix {};
      kwayland = callPackage ./kwayland.nix {};
      kwidgetsaddons = callPackage ./kwidgetsaddons.nix {};
      kwindowsystem = callPackage ./kwindowsystem {};
      modemmanager-qt = callPackage ./modemmanager-qt.nix {};
      networkmanager-qt = callPackage ./networkmanager-qt.nix {};
      oxygen-icons5 = callPackage ./oxygen-icons5.nix {};
      prison = callPackage ./prison.nix {};
      qqc2-desktop-style = callPackage ./qqc2-desktop-style.nix {};
      solid = callPackage ./solid {};
      sonnet = callPackage ./sonnet.nix {};
      syntax-highlighting = callPackage ./syntax-highlighting.nix {};
      threadweaver = callPackage ./threadweaver.nix {};

    # TIER 2
      kactivities = callPackage ./kactivities.nix {};
      kauth = callPackage ./kauth {};
      kcompletion = callPackage ./kcompletion.nix {};
      kcontacts = callPackage ./kcontacts.nix {};
      kcrash = callPackage ./kcrash.nix {};
      kdoctools = callPackage ./kdoctools {};
      kfilemetadata = callPackage ./kfilemetadata {};
      kimageformats = callPackage ./kimageformats.nix {};
      kjobwidgets = callPackage ./kjobwidgets.nix {};
      knotifications = callPackage ./knotifications.nix {};
      kpackage = callPackage ./kpackage {};
      kpeople = callPackage ./kpeople.nix {};
      kpty = callPackage ./kpty.nix {};
      kunitconversion = callPackage ./kunitconversion.nix {};
      syndication = callPackage ./syndication.nix {};

    # TIER 3
      baloo = callPackage ./baloo.nix {};
      kactivities-stats = callPackage ./kactivities-stats.nix {};
      kbookmarks = callPackage ./kbookmarks.nix {};
      kcmutils = callPackage ./kcmutils.nix {};
      kconfigwidgets = callPackage ./kconfigwidgets.nix {};
      kdav = callPackage ./kdav.nix {};
      kdeclarative = callPackage ./kdeclarative.nix {};
      kded = callPackage ./kded.nix {};
      kdesu = callPackage ./kdesu {};
      kemoticons = callPackage ./kemoticons.nix {};
      kglobalaccel = callPackage ./kglobalaccel.nix {};
      kiconthemes = callPackage ./kiconthemes {};
      kinit = callPackage ./kinit {};
      kio = callPackage ./kio {};
      knewstuff = callPackage ./knewstuff {};
      knotifyconfig = callPackage ./knotifyconfig.nix {};
      kparts = callPackage ./kparts.nix {};
      krunner = callPackage ./krunner.nix {};
      kservice = callPackage ./kservice {};
      ktexteditor = callPackage ./ktexteditor.nix {};
      ktextwidgets = callPackage ./ktextwidgets.nix {};
      kwallet = callPackage ./kwallet.nix {};
      kxmlgui = callPackage ./kxmlgui.nix {};
      plasma-framework = callPackage ./plasma-framework.nix {};
      kpurpose = callPackage ./purpose.nix {};

    # TIER 4
      frameworkintegration = callPackage ./frameworkintegration.nix {};

    # PORTING AIDS
      kdelibs4support = callPackage ./kdelibs4support {};
      kdesignerplugin = callPackage ./kdesignerplugin.nix {};
      khtml = callPackage ./khtml.nix {};
      kjs = callPackage ./kjs.nix {};
      kjsembed = callPackage ./kjsembed.nix {};
      kmediaplayer = callPackage ./kmediaplayer.nix {};
      kross = callPackage ./kross.nix {};
      kxmlrpcclient = callPackage ./kxmlrpcclient.nix {};

    };

in lib.makeScope libsForQt5.newScope packages
