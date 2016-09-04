/*

# Updates

1. Update the URL in `maintainers/scripts/generate-kde-applications.sh` and
   run that script from the top of the Nixpkgs tree.
2. Check that the new packages build correctly.
3. Commit the changes and open a pull request.

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

    ark = callPackage ./ark/default.nix {};
    baloo-widgets = callPackage ./baloo-widgets.nix {};
    dolphin = callPackage ./dolphin.nix {};
    dolphin-plugins = callPackage ./dolphin-plugins.nix {};
    ffmpegthumbs = callPackage ./ffmpegthumbs.nix {
      ffmpeg = pkgs.ffmpeg_2;
    };
    filelight = callPackage ./filelight.nix {};
    gpgmepp = callPackage ./gpgmepp.nix {};
    gwenview = callPackage ./gwenview.nix {};
    kate = callPackage ./kate.nix {};
    kdenlive = callPackage ./kdenlive.nix {};
    kcalc = callPackage ./kcalc.nix {};
    kcolorchooser = callPackage ./kcolorchooser.nix {};
    kdegraphics-thumbnailers = callPackage ./kdegraphics-thumbnailers.nix {};
    kdenetwork-filesharing = callPackage ./kdenetwork-filesharing.nix {};
    kdf = callPackage ./kdf.nix {};
    kgpg = callPackage ./kgpg.nix { inherit (pkgs.kde4) kdepimlibs; };
    khelpcenter = callPackage ./khelpcenter.nix {};
    kio-extras = callPackage ./kio-extras.nix {};
    kompare = callPackage ./kompare.nix {};
    konsole = callPackage ./konsole.nix {};
    libkdcraw = callPackage ./libkdcraw.nix {};
    libkexiv2 = callPackage ./libkexiv2.nix {};
    libkipi = callPackage ./libkipi.nix {};
    libkomparediff2 = callPackage ./libkomparediff2.nix {};
    okular = callPackage ./okular.nix {};
    print-manager = callPackage ./print-manager.nix {};
    spectacle = callPackage ./spectacle.nix {};

    l10n = pkgs.recurseIntoAttrs (import ./l10n.nix { inherit callPackage lib pkgs; });
  };

in packages
