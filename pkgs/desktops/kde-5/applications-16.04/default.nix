# Maintainer's Notes:
#
# Minor updates:
#  1. Edit ./manifest.sh to point to the updated URL. Upstream sometimes
#     releases updates that include only the changed packages; in this case,
#     multiple URLs can be provided and the results will be merged.
#  2. Run ./manifest.sh and ./dependencies.sh.
#  3. Build and enjoy.
#
# Major updates:
#  We prefer not to immediately overwrite older versions with major updates, so
#  make a copy of this directory first. After copying, be sure to delete ./tmp
#  if it exists. Then follow the minor update instructions.

{ pkgs, debug ? false }:

let

  inherit (pkgs) fetchurl lib stdenv;

  mirror = "mirror://kde";
  remotesrcs = fetchurl {
    url = "https://raw.githubusercontent.com/ttuegel/nixpkgs-kde-qt/580915a460b11820c0b671236255180af5264c0c/applications-srcs.nix";
    sha256 = "19lwhn468p9v8p97vyy23q5mv0yxs394lsfl41ij3glrxd92s8kf";
  };
  srcs = import remotesrcs { inherit (pkgs) fetchurl; inherit mirror; };

  packages = self: with self; {

    kdeApp = import ./kde-app.nix {
      inherit stdenv lib;
      inherit debug srcs;
    };

    kdelibs = callPackage ./kdelibs { inherit (pkgs) attica phonon; };

    ark = callPackage ./ark.nix {};
    baloo-widgets = callPackage ./baloo-widgets.nix {};
    dolphin = callPackage ./dolphin.nix {};
    dolphin-plugins = callPackage ./dolphin-plugins.nix {};
    ffmpegthumbs = callPackage ./ffmpegthumbs.nix {};
    filelight = callPackage ./filelight.nix {};
    gpgmepp = callPackage ./gpgmepp.nix {};
    gwenview = callPackage ./gwenview.nix {};
    kate = callPackage ./kate.nix {};
    kcalc = callPackage ./kcalc.nix {};
    kcolorchooser = callPackage ./kcolorchooser.nix {};
    kdegraphics-thumbnailers = callPackage ./kdegraphics-thumbnailers.nix {};
    kdenetwork-filesharing = callPackage ./kdenetwork-filesharing.nix {};
    kgpg = callPackage ./kgpg.nix { inherit (pkgs.kde4) kdepimlibs; };
    kio-extras = callPackage ./kio-extras.nix {};
    konsole = callPackage ./konsole.nix {};
    libkdcraw = callPackage ./libkdcraw.nix {};
    libkexiv2 = callPackage ./libkexiv2.nix {};
    libkipi = callPackage ./libkipi.nix {};
    okular = callPackage ./okular.nix {};
    print-manager = callPackage ./print-manager.nix {};
    spectacle = callPackage ./spectacle.nix {};

    l10n = pkgs.recurseIntoAttrs (import ./l10n.nix { inherit callPackage lib pkgs; });
  };

in packages
