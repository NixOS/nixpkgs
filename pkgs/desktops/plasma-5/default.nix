/*

# New packages

READ THIS FIRST

This module is for official packages in KDE Plasma 5. All available packages are
listed in `./srcs.nix`, although a few are not yet packaged in Nixpkgs (see
below).

IF YOUR PACKAGE IS NOT LISTED IN `./srcs.nix`, IT DOES NOT GO HERE.

Many of the packages released upstream are not yet built in Nixpkgs due to lack
of demand. To add a Nixpkgs build for an upstream package, copy one of the
existing packages here and modify it as necessary.

# Updates

1. Update the URL in `./fetch.sh`.
2. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/desktops/plasma-5`
   from the top of the Nixpkgs tree.
3. Use `nox-review wip` to check that everything builds.
4. Commit the changes and open a pull request.

*/

{
  libsForQt5, lib, fetchurl,
  gconf, gsettings-desktop-schemas
}:

let
  srcs = import ./srcs.nix {
    inherit fetchurl;
    mirror = "mirror://kde";
  };

  mkDerivation = libsForQt5.callPackage ({ mkDerivation }: mkDerivation) {};

  packages = self: with self;
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
                        propagatedBuildInputs="$propagatedBuildInputs @dev@"
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
            sname = args.sname or name;
            inherit (srcs."${sname}") src version;

            outputs = args.outputs or [ "out" ];
            hasBin = lib.elem "bin" outputs;
            hasDev = lib.elem "dev" outputs;

            defaultSetupHook = if hasBin && hasDev then propagateBin else null;
            setupHook = args.setupHook or defaultSetupHook;

            meta = {
              license = with lib.licenses; [
                lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
              ];
              platforms = lib.platforms.linux;
              maintainers = with lib.maintainers; [ ttuegel ];
              homepage = http://www.kde.org;
            } // (args.meta or {});
          in
          mkDerivation (args // {
            name = "${name}-${version}";
            inherit meta outputs setupHook src;
          });
      };

    in {
      bluedevil = callPackage ./bluedevil.nix {};
      breeze-gtk = callPackage ./breeze-gtk.nix {};
      breeze-qt5 = callPackage ./breeze-qt5.nix {};
      breeze-grub = callPackage ./breeze-grub.nix {};
      breeze-plymouth = callPackage ./breeze-plymouth {};
      discover = callPackage ./discover.nix {};
      kactivitymanagerd = callPackage ./kactivitymanagerd.nix {};
      kde-cli-tools = callPackage ./kde-cli-tools.nix {};
      kde-gtk-config = callPackage ./kde-gtk-config { inherit gsettings-desktop-schemas; };
      kdecoration = callPackage ./kdecoration.nix {};
      kdeplasma-addons = callPackage ./kdeplasma-addons.nix {};
      kgamma5 = callPackage ./kgamma5.nix {};
      khotkeys = callPackage ./khotkeys.nix {};
      kinfocenter = callPackage ./kinfocenter.nix {};
      kmenuedit = callPackage ./kmenuedit.nix {};
      kscreen = callPackage ./kscreen.nix {};
      kscreenlocker = callPackage ./kscreenlocker.nix {};
      ksshaskpass = callPackage ./ksshaskpass.nix {};
      ksysguard = callPackage ./ksysguard.nix {};
      kwallet-pam = callPackage ./kwallet-pam.nix {};
      kwayland-integration = callPackage ./kwayland-integration.nix {};
      kwin = callPackage ./kwin {};
      kwrited = callPackage ./kwrited.nix {};
      libkscreen = callPackage ./libkscreen {};
      libksysguard = callPackage ./libksysguard {};
      milou = callPackage ./milou.nix {};
      oxygen = callPackage ./oxygen.nix {};
      plasma-browser-integration = callPackage ./plasma-browser-integration.nix {};
      plasma-desktop = callPackage ./plasma-desktop {};
      plasma-integration = callPackage ./plasma-integration {};
      plasma-nm = callPackage ./plasma-nm {};
      plasma-pa = callPackage ./plasma-pa.nix { inherit gconf; };
      plasma-vault = callPackage ./plasma-vault {};
      plasma-workspace = callPackage ./plasma-workspace {};
      plasma-workspace-wallpapers = callPackage ./plasma-workspace-wallpapers.nix {};
      polkit-kde-agent = callPackage ./polkit-kde-agent.nix {};
      powerdevil = callPackage ./powerdevil.nix {};
      sddm-kcm = callPackage ./sddm-kcm.nix {};
      systemsettings = callPackage ./systemsettings.nix {};
      user-manager = callPackage ./user-manager.nix {};
      xdg-desktop-portal-kde = callPackage ./xdg-desktop-portal-kde.nix {};
    };
in
lib.makeScope libsForQt5.newScope packages
