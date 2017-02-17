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
2. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/desktops/kde-5/plasma`
   from the top of the Nixpkgs tree.
3. Invoke `nix-build -A kde5` and ensure that everything builds.
4. Commit the changes and open a pull request.

*/

{ pkgs, debug ? false }:

let

  inherit (pkgs) lib makeSetupHook stdenv symlinkJoin;

  mirror = "mirror://kde";
  srcs = import ./srcs.nix { inherit (pkgs) fetchurl; inherit mirror; };

  packages = self: with self; {
    plasmaPackage = args:
      let
        inherit (args) name;
        sname = args.sname or name;
        inherit (srcs."${sname}") src version;
      in kdeDerivation (args // {
        name = "${name}-${version}";
        inherit src;

        meta = {
          license = with lib.licenses; [
            lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
          ];
          platforms = lib.platforms.linux;
          maintainers = with lib.maintainers; [ ttuegel ];
          homepage = "http://www.kde.org";
        } // (args.meta or {});
      });

    bluedevil = callPackage ./bluedevil.nix {};
    breeze-gtk = callPackage ./breeze-gtk.nix {};
    breeze-qt4 = callPackage ./breeze-qt4.nix {
      inherit (srcs.breeze) src version;
    };
    breeze-qt5 = callPackage ./breeze-qt5.nix {};
    breeze-grub = callPackage ./breeze-grub.nix {};
    breeze-plymouth = callPackage ./breeze-plymouth {};
    kactivitymanagerd = callPackage ./kactivitymanagerd.nix {};
    kde-cli-tools = callPackage ./kde-cli-tools.nix {};
    kde-gtk-config = callPackage ./kde-gtk-config {};
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
    libkscreen = callPackage ./libkscreen.nix {};
    libksysguard = callPackage ./libksysguard {};
    milou = callPackage ./milou.nix {};
    oxygen = callPackage ./oxygen.nix {};
    plasma-desktop = callPackage ./plasma-desktop {};
    plasma-integration = callPackage ./plasma-integration.nix {};
    plasma-nm = callPackage ./plasma-nm {};
    plasma-pa = callPackage ./plasma-pa.nix {
      inherit (pkgs.gnome3) gconf;
    };
    plasma-workspace = callPackage ./plasma-workspace {};
    plasma-workspace-wallpapers = callPackage ./plasma-workspace-wallpapers.nix {};
    polkit-kde-agent = callPackage ./polkit-kde-agent.nix {};
    powerdevil = callPackage ./powerdevil.nix {};
    startkde = callPackage ./startkde {};
    systemsettings = callPackage ./systemsettings.nix {};
  };

in packages
