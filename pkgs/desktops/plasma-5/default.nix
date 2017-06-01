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
  libsForQt5, kdeDerivation, lib, fetchurl,
  gconf,
  debug ? false,
}:

let
  packages = self: with self;
    let
      callPackage = self.newScope {
        plasmaPackage = import ./build-support/package.nix {
          inherit kdeDerivation lib fetchurl;
        };
      };
    in {
      bluedevil = callPackage ./bluedevil.nix {};
      breeze-gtk = callPackage ./breeze-gtk.nix {};
      breeze-qt4 = callPackage ./breeze-qt4.nix {};
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
      libkscreen = callPackage ./libkscreen {};
      libksysguard = callPackage ./libksysguard {};
      milou = callPackage ./milou.nix {};
      oxygen = callPackage ./oxygen.nix {};
      plasma-desktop = callPackage ./plasma-desktop {};
      plasma-integration = callPackage ./plasma-integration.nix {};
      plasma-nm = callPackage ./plasma-nm {};
      plasma-pa = callPackage ./plasma-pa.nix { inherit gconf; };
      plasma-workspace = callPackage ./plasma-workspace {};
      plasma-workspace-wallpapers = callPackage ./plasma-workspace-wallpapers.nix {};
      polkit-kde-agent = callPackage ./polkit-kde-agent.nix {};
      powerdevil = callPackage ./powerdevil.nix {};
      startkde = callPackage ./startkde {};
      systemsettings = callPackage ./systemsettings.nix {};
    };
in
lib.makeScope libsForQt5.newScope packages
