/*

# Updates

Before a major version update, make a copy of this directory. (We like to
keep the old version around for a short time after major updates.)

1. Update the URL in `maintainers/scripts/generate-kde-applications.sh`.
2. From the top of the Nixpkgs tree, run
   `./maintainers/scripts/generate-kde-applications.sh > pkgs/desktops/kde-5/applications-$VERSION/srcs.nix`.
3. Check that the new packages build correctly.
4. Commit the changes and open a pull request.

*/

{ pkgs, debug ? false }:

let

  inherit (pkgs) lib stdenv;

  mirror = "mirror://kde";
  srcs = import ./srcs.nix { inherit (pkgs) fetchurl; inherit mirror; };

  packages = self: with self; {

    kdeApp = import ./kde-app.nix {
      inherit stdenv lib;
      inherit debug srcs;
    };

    kdelibs = callPackage ./kdelibs { inherit (pkgs) attica phonon; };

    akonadi = callPackage ./akonadi.nix {};
    ark = callPackage ./ark/default.nix {};
    baloo-widgets = callPackage ./baloo-widgets.nix {};
    dolphin = callPackage ./dolphin.nix {};
    dolphin-plugins = callPackage ./dolphin-plugins.nix {};
    ffmpegthumbs = callPackage ./ffmpegthumbs.nix {
      ffmpeg = pkgs.ffmpeg_2;
    };
    filelight = callPackage ./filelight.nix {};
    gpgmepp = callPackage ./gpgmepp.nix {};
    grantleetheme = callPackage ./grantleetheme.nix {};
    gwenview = callPackage ./gwenview.nix {};
    kalarmcal = callPackage ./kalarmcal.nix {};
    kate = callPackage ./kate.nix {};
    kblog = callPackage ./kblog.nix {};
    kcalc = callPackage ./kcalc.nix {};
    kcalcore = callPackage ./kcalcore.nix {};
    kcalutils = callPackage ./kcalutils.nix {};
    kcolorchooser = callPackage ./kcolorchooser.nix {};
    kcontacts = callPackage ./kcontacts.nix {};
    kdegraphics-thumbnailers = callPackage ./kdegraphics-thumbnailers.nix {};
    kdenetwork-filesharing = callPackage ./kdenetwork-filesharing.nix {};
    kdgantt2 = callPackage ./kdgantt2.nix {};
    kgpg = callPackage ./kgpg.nix { inherit (pkgs.kde4) kdepimlibs; };
    khelpcenter = callPackage ./khelpcenter.nix {};
    kholidays = callPackage ./kholidays.nix {};
    kidentitymanagement = callPackage ./kidentitymanagement.nix {};
    kimap = callPackage ./kimap.nix {};
    kio-extras = callPackage ./kio-extras.nix {};
    kldap = callPackage ./kldap.nix {};
    kmbox = callPackage ./kmbox.nix {};
    kmime = callPackage ./kmime.nix {};
    kompare = callPackage ./kompare.nix {};
    konsole = callPackage ./konsole.nix {};
    kontactinterface = callPackage ./kontactinterface.nix {};
    kpimtextedit = callPackage ./kpimtextedit.nix {};
    ktnef = callPackage ./ktnef.nix {};
    libkdcraw = callPackage ./libkdcraw.nix {};
    libkexiv2 = callPackage ./libkexiv2.nix {};
    libkipi = callPackage ./libkipi.nix {};
    libkleo = callPackage ./libkleo.nix {};
    libkomparediff2 = callPackage ./libkomparediff2.nix {};
    okular = callPackage ./okular.nix {};
    print-manager = callPackage ./print-manager.nix {};
    spectacle = callPackage ./spectacle.nix {};
    syndication = callPackage ./syndication.nix {};

    l10n = pkgs.recurseIntoAttrs (import ./l10n.nix { inherit callPackage lib pkgs; });
  };

in packages
