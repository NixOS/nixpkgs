/*

# New packages

READ THIS FIRST

This module is for official packages in the KDE Applications Bundle. All
available packages are listed in `./srcs.nix`, although some are not yet
packaged in Nixpkgs (see below).

IF YOUR PACKAGE IS NOT LISTED IN `./srcs.nix`, IT DOES NOT GO HERE.

Many of the packages released upstream are not yet built in Nixpkgs due to lack
of demand. To add a Nixpkgs build for an upstream package, copy one of the
existing packages here and modify it as necessary. A simple example package that
still shows most of the available features is in `./gwenview.nix`.

# Updates

1. Update the URL in `./fetch.sh`.
2. Run `./maintainers/scripts/fetch-kde-qt.sh pkgs/desktops/kde-5/applications`
   from the top of the Nixpkgs tree.
3. Invoke `nix-build -A kde5` and ensure that everything builds.
4. Commit the changes and open a pull request.

*/

{ pkgs, debug ? false }:

let

  inherit (pkgs) lib stdenv;

  mirror = "mirror://kde";
  srcs = import ./srcs.nix { inherit (pkgs) fetchurl; inherit mirror; };

  packages = self: with self; {

    kdeApp = import ./kde-app.nix {
      inherit lib;
      inherit debug srcs;
      inherit kdeDerivation;
    };

    kdelibs = callPackage ./kdelibs {
      inherit (srcs.kdelibs) src version;
      inherit (pkgs) attica phonon;
    };

    akonadi = callPackage ./akonadi.nix {};
    akonadi-contacts = callPackage ./akonadi-contacts.nix {};
    akonadi-mime = callPackage ./akonadi-mime.nix {};
    ark = callPackage ./ark/default.nix {};
    baloo-widgets = callPackage ./baloo-widgets.nix {};
    dolphin = callPackage ./dolphin.nix {};
    dolphin-plugins = callPackage ./dolphin-plugins.nix {};
    ffmpegthumbs = callPackage ./ffmpegthumbs.nix {
      ffmpeg = pkgs.ffmpeg_2;
    };
    filelight = callPackage ./filelight.nix {};
    gwenview = callPackage ./gwenview.nix {};
    kate = callPackage ./kate.nix {};
    kdenlive = callPackage ./kdenlive.nix {};
    kcalc = callPackage ./kcalc.nix {};
    kcolorchooser = callPackage ./kcolorchooser.nix {};
    kcontacts = callPackage ./kcontacts.nix {};
    kdegraphics-mobipocket = callPackage ./kdegraphics-mobipocket.nix {};
    kdegraphics-thumbnailers = callPackage ./kdegraphics-thumbnailers.nix {};
    kdenetwork-filesharing = callPackage ./kdenetwork-filesharing.nix {};
    kdf = callPackage ./kdf.nix {};
    kgpg = callPackage ./kgpg.nix {};
    khelpcenter = callPackage ./khelpcenter.nix {};
    kio-extras = callPackage ./kio-extras.nix {};
    kmime = callPackage ./kmime.nix {};
    kmix = callPackage ./kmix.nix {};
    kompare = callPackage ./kompare.nix {};
    konsole = callPackage ./konsole.nix {};
    kwalletmanager = callPackage ./kwalletmanager.nix {};
    libkdcraw = callPackage ./libkdcraw.nix {};
    libkexiv2 = callPackage ./libkexiv2.nix {};
    libkipi = callPackage ./libkipi.nix {};
    libkomparediff2 = callPackage ./libkomparediff2.nix {};
    marble = callPackage ./marble.nix {};
    okteta = callPackage ./okteta.nix {};
    okular = callPackage ./okular.nix {};
    print-manager = callPackage ./print-manager.nix {};
    spectacle = callPackage ./spectacle.nix {};

    l10n = pkgs.recurseIntoAttrs (import ./l10n.nix { inherit callPackage lib pkgs; });
  };

in packages
