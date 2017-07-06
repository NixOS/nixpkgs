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

  srcs = import ./srcs.nix {
    inherit fetchurl;
    mirror = "mirror://kde";
  };

  mkDerivation = libsForQt5.callPackage ({ mkDerivation }: mkDerivation) {};

  packages = self: with self;
    # SUPPORT
    let

      propagate = out:
        let setupHook = { writeScript }:
              writeScript "setup-hook" ''
                if [ "$hookName" != postHook ]; then
                    postHooks+=("source @dev@/nix-support/setup-hook")
                else
                    # Propagate $${out} output
                    propagatedUserEnvPkgs="$propagatedUserEnvPkgs @${out}@"

                    if [ -z "$outputDev" ]; then
                        echo "error: \$outputDev is unset!" >&2
                        exit 1
                    fi

                    # Propagate $dev so that this setup hook is propagated
                    # But only if there is a separate $dev output
                    if [ "$outputDev" != out ]; then
                        if [ -n "$crossConfig" ]; then
                          propagatedBuildInputs="$propagatedBuildInputs @dev@"
                        else
                          propagatedNativeBuildInputs="$propagatedNativeBuildInputs @dev@"
                        fi
                    fi
                fi
              '';
        in callPackage setupHook {};

      propagateBin = propagate "bin";

      callPackage = self.newScope {

        inherit propagate propagateBin;

        mkDerivation = args:
          let

            inherit (args) name;
            inherit (srcs."${name}") src version;

            outputs = args.outputs or [ "out" "dev" "bin" ];
            hasBin = lib.elem "bin" outputs;
            hasDev = lib.elem "dev" outputs;

            defaultSetupHook = if hasBin && hasDev then propagateBin else null;
            setupHook = args.setupHook or defaultSetupHook;

            meta = {
              homepage = "http://www.kde.org";
              license = with lib.licenses; [
                lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
              ];
              maintainers = [ lib.maintainers.ttuegel ];
              platforms = lib.platforms.linux;
            } // (args.meta or {});

          in mkDerivation (args // {
            name = "${name}-${version}";
            inherit meta outputs setupHook src;
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
      kcodecs = callPackage ./kcodecs.nix {};
      kconfig = callPackage ./kconfig.nix {};
      kcoreaddons = callPackage ./kcoreaddons.nix {};
      kdbusaddons = callPackage ./kdbusaddons.nix {};
      kdnssd = callPackage ./kdnssd.nix {};
      kguiaddons = callPackage ./kguiaddons.nix {};
      ki18n = callPackage ./ki18n.nix {};
      kidletime = callPackage ./kidletime.nix {};
      kitemmodels = callPackage ./kitemmodels.nix {};
      kitemviews = callPackage ./kitemviews.nix {};
      kplotting = callPackage ./kplotting.nix {};
      kwayland = callPackage ./kwayland.nix {};
      kwidgetsaddons = callPackage ./kwidgetsaddons.nix {};
      kwindowsystem = callPackage ./kwindowsystem {};
      modemmanager-qt = callPackage ./modemmanager-qt.nix {};
      networkmanager-qt = callPackage ./networkmanager-qt.nix {};
      oxygen-icons5 = callPackage ./oxygen-icons5.nix {};
      prison = callPackage ./prison.nix {};
      solid = callPackage ./solid.nix {};
      sonnet = callPackage ./sonnet.nix {};
      syntax-highlighting = callPackage ./syntax-highlighting.nix {};
      threadweaver = callPackage ./threadweaver.nix {};

    # TIER 2
      kactivities = callPackage ./kactivities.nix {};
      kactivities-stats = callPackage ./kactivities-stats.nix {};
      kauth = callPackage ./kauth {};
      kcompletion = callPackage ./kcompletion.nix {};
      kcrash = callPackage ./kcrash.nix {};
      kdoctools = callPackage ./kdoctools {};
      kfilemetadata = callPackage ./kfilemetadata {};
      kimageformats = callPackage ./kimageformats.nix {};
      kjobwidgets = callPackage ./kjobwidgets.nix {};
      knotifications = callPackage ./knotifications.nix {};
      kpackage = callPackage ./kpackage {};
      kpty = callPackage ./kpty.nix {};
      kunitconversion = callPackage ./kunitconversion.nix {};

    # TIER 3
      baloo = callPackage ./baloo.nix {};
      kbookmarks = callPackage ./kbookmarks.nix {};
      kcmutils = callPackage ./kcmutils {};
      kconfigwidgets = callPackage ./kconfigwidgets {};
      kdeclarative = callPackage ./kdeclarative.nix {};
      kded = callPackage ./kded.nix {};
      kdesignerplugin = callPackage ./kdesignerplugin.nix {};
      kdesu = callPackage ./kdesu.nix {};
      kemoticons = callPackage ./kemoticons.nix {};
      kglobalaccel = callPackage ./kglobalaccel.nix {};
      kiconthemes = callPackage ./kiconthemes {};
      kinit = callPackage ./kinit {};
      kio = callPackage ./kio {};
      knewstuff = callPackage ./knewstuff.nix {};
      knotifyconfig = callPackage ./knotifyconfig.nix {};
      kparts = callPackage ./kparts.nix {};
      kpeople = callPackage ./kpeople.nix {};
      krunner = callPackage ./krunner.nix {};
      kservice = callPackage ./kservice {};
      ktexteditor = callPackage ./ktexteditor.nix {};
      ktextwidgets = callPackage ./ktextwidgets.nix {};
      kwallet = callPackage ./kwallet.nix {};
      kxmlgui = callPackage ./kxmlgui.nix {};
      kxmlrpcclient = callPackage ./kxmlrpcclient.nix {};
      plasma-framework = callPackage ./plasma-framework.nix {};

    # TIER 4
      frameworkintegration = callPackage ./frameworkintegration.nix {};

    # PORTING AIDS
      kdelibs4support = callPackage ./kdelibs4support {};
      khtml = callPackage ./khtml.nix {};
      kjs = callPackage ./kjs.nix {};
      kjsembed = callPackage ./kjsembed.nix {};
      kmediaplayer = callPackage ./kmediaplayer.nix {};
      kross = callPackage ./kross.nix {};

    };

in lib.makeScope libsForQt5.newScope packages
