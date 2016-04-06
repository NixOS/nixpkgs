# Maintainer's Notes:
#
# How To Update
#  1. Edit the URL in ./manifest.sh
#  2. Run ./manifest.sh
#  3. Fix build errors.

{ pkgs, debug ? false }:

let

  inherit (pkgs) lib stdenv symlinkJoin;

  kdeApps = pkgs.kdeApps_15_12;

  srcs = import ./srcs.nix { inherit (pkgs) fetchurl; inherit mirror; };
  mirror = "mirror://kde";

  packages = self: with self; {
    plasmaPackage = args:
      let
        inherit (args) name;
        sname = args.sname or name;
        inherit (srcs."${sname}") src version;
      in stdenv.mkDerivation (args // {
        name = "${name}-${version}";
        inherit src;

        setupHook = args.setupHook or ./setup-hook.sh;

        cmakeFlags =
          (args.cmakeFlags or [])
          ++ [ "-DBUILD_TESTING=OFF" ]
          ++ lib.optional debug "-DCMAKE_BUILD_TYPE=Debug";

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
    breeze-qt4 = callPackage ./breeze-qt4.nix {};
    breeze-qt5 = callPackage ./breeze-qt5.nix {};
    breeze =
      let version = (builtins.parseDrvName breeze-qt5.name).version;
      in symlinkJoin "breeze-${version}" [ breeze-gtk breeze-qt4 breeze-qt5 ];
    kde-cli-tools = callPackage ./kde-cli-tools.nix {};
    kde-gtk-config = callPackage ./kde-gtk-config {};
    kdecoration = callPackage ./kdecoration.nix {};
    kdeplasma-addons = callPackage ./kdeplasma-addons.nix {};
    kgamma5 = callPackage ./kgamma5.nix {};
    khelpcenter = callPackage ./khelpcenter.nix {};
    khotkeys = callPackage ./khotkeys.nix {};
    kinfocenter = callPackage ./kinfocenter.nix {};
    kmenuedit = callPackage ./kmenuedit.nix {};
    kscreen = callPackage ./kscreen.nix {};
    kscreenlocker = callPackage ./kscreenlocker.nix {};
    ksshaskpass = callPackage ./ksshaskpass.nix {};
    ksysguard = callPackage ./ksysguard.nix {};
    kwayland = callPackage ./kwayland.nix {};
    kwayland-integration = callPackage ./kwayland-integration.nix {};
    kwin = callPackage ./kwin {};
    kwrited = callPackage ./kwrited.nix {};
    libkscreen = callPackage ./libkscreen {};
    libksysguard = callPackage ./libksysguard {};
    milou = callPackage ./milou.nix {};
    oxygen = callPackage ./oxygen.nix {};
    plasma-desktop = callPackage ./plasma-desktop {};
    plasma-mediacenter = callPackage ./plasma-mediacenter.nix {};
    plasma-nm = callPackage ./plasma-nm {};
    plasma-pa = callPackage ./plasma-pa.nix {};
    plasma-workspace = callPackage ./plasma-workspace {};
    plasma-workspace-wallpapers = callPackage ./plasma-workspace-wallpapers.nix {};
    polkit-kde-agent = callPackage ./polkit-kde-agent.nix {};
    powerdevil = callPackage ./powerdevil.nix {};
    systemsettings = callPackage ./systemsettings.nix {};
  };

in packages
