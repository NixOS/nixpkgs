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

{ libsForQt5
, lib
, config
, fetchurl
, gconf
, gsettings-desktop-schemas
}:

let
  maintainers = with lib.maintainers; [ ttuegel nyanloutre ];
  license = with lib.licenses; [
    lgpl21Plus
    lgpl3Plus
    bsd2
    mit
    gpl2Plus
    gpl3Plus
    fdl12Plus
  ];

  srcs = import ./srcs.nix {
    inherit fetchurl;
    mirror = "mirror://kde";
  };

  qtStdenv = libsForQt5.callPackage ({ stdenv }: stdenv) { };

  packages = self:
    let

      propagate = out:
        let
          setupHook = { writeScript }:
            writeScript "setup-hook" ''
              if [[ "''${hookName-}" != postHook ]]; then
                  postHooks+=("source @dev@/nix-support/setup-hook")
              else
                  # Propagate $${out} output
                  propagatedUserEnvPkgs+=" @${out}@"

                  if [ -z "$outputDev" ]; then
                      echo "error: \$outputDev is unset!" >&2
                      exit 1
                  fi

                  # Propagate $dev so that this setup hook is propagated
                  # But only if there is a separate $dev output
                  if [ "$outputDev" != out ]; then
                      propagatedBuildInputs+=" @dev@"
                  fi
              fi
            '';
        in
        callPackage setupHook { };

      propagateBin = propagate "bin";

      callPackage = self.newScope {
        inherit propagate propagateBin;

        mkDerivation = args:
          let
            inherit (args) pname;
            sname = args.sname or pname;
            inherit (srcs.${sname}) src version;

            outputs = args.outputs or [ "out" ];
            hasBin = lib.elem "bin" outputs;
            hasDev = lib.elem "dev" outputs;

            defaultSetupHook = if hasBin && hasDev then propagateBin else null;
            setupHook = args.setupHook or defaultSetupHook;
            nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ libsForQt5.wrapQtAppsHook ];

            meta =
              let meta = args.meta or { }; in
              meta // {
                homepage = meta.homepage or "http://www.kde.org";
                license = meta.license or license;
                maintainers = (meta.maintainers or [ ]) ++ maintainers;
                platforms = meta.platforms or lib.platforms.linux;
              };
          in
          qtStdenv.mkDerivation (args // {
            inherit pname version meta outputs setupHook src nativeBuildInputs;
          });
      };

    in
    {
      aura-browser = callPackage ./aura-browser.nix { };
      bluedevil = callPackage ./bluedevil.nix { };
      breeze-gtk = callPackage ./breeze-gtk.nix { };
      breeze-qt5 = callPackage ./breeze-qt5.nix { };
      breeze-grub = callPackage ./breeze-grub.nix { };
      breeze-plymouth = callPackage ./breeze-plymouth { };
      discover = callPackage ./discover.nix { };
      flatpak-kcm = callPackage ./flatpak-kcm.nix { };
      kactivitymanagerd = callPackage ./kactivitymanagerd.nix { };
      kde-cli-tools = callPackage ./kde-cli-tools.nix { };
      kde-gtk-config = callPackage ./kde-gtk-config { inherit gsettings-desktop-schemas; };
      kdecoration = callPackage ./kdecoration.nix { };
      kdeplasma-addons = callPackage ./kdeplasma-addons.nix { };
      kgamma5 = callPackage ./kgamma5.nix { };
      khotkeys = callPackage ./khotkeys.nix { };
      kinfocenter = callPackage ./kinfocenter { };
      kmenuedit = callPackage ./kmenuedit.nix { };
      kpipewire = callPackage ./kpipewire.nix { };
      kscreen = callPackage ./kscreen.nix { };
      kscreenlocker = callPackage ./kscreenlocker.nix { };
      ksshaskpass = callPackage ./ksshaskpass.nix { };
      ksystemstats = callPackage ./ksystemstats.nix { };
      kwallet-pam = callPackage ./kwallet-pam.nix { };
      kwayland-integration = callPackage ./kwayland-integration.nix { };
      kwin = callPackage ./kwin { };
      kwrited = callPackage ./kwrited.nix { };
      layer-shell-qt = callPackage ./layer-shell-qt.nix { };
      libkscreen = callPackage ./libkscreen { };
      libksysguard = callPackage ./libksysguard { };
      milou = callPackage ./milou.nix { };
      oxygen = callPackage ./oxygen.nix { };
      oxygen-sounds = callPackage ./oxygen-sounds.nix { };
      plank-player = callPackage ./plank-player.nix { };
      plasma-bigscreen = callPackage ./plasma-bigscreen.nix { };
      plasma-browser-integration = callPackage ./plasma-browser-integration.nix { };
      plasma-desktop = callPackage ./plasma-desktop { };
      plasma-disks = callPackage ./plasma-disks.nix { };
      plasma-firewall = callPackage ./plasma-firewall.nix { };
      plasma-integration = callPackage ./plasma-integration { };
      plasma-mobile = callPackage ./plasma-mobile { };
      plasma-nano = callPackage ./plasma-nano { };
      plasma-nm = callPackage ./plasma-nm { };
      plasma-pa = callPackage ./plasma-pa.nix { inherit gconf; };
      plasma-remotecontrollers = callPackage ./plasma-remotecontrollers.nix { };
      plasma-sdk = callPackage ./plasma-sdk.nix { };
      plasma-systemmonitor = callPackage ./plasma-systemmonitor.nix { };
      plasma-thunderbolt = callPackage ./plasma-thunderbolt.nix { };
      plasma-vault = callPackage ./plasma-vault { };
      plasma-welcome = callPackage ./plasma-welcome.nix { };
      plasma-workspace = callPackage ./plasma-workspace { };
      plasma-workspace-wallpapers = callPackage ./plasma-workspace-wallpapers.nix { };
      polkit-kde-agent = callPackage ./polkit-kde-agent.nix { };
      powerdevil = callPackage ./powerdevil.nix { };
      qqc2-breeze-style = callPackage ./qqc2-breeze-style.nix { };
      sddm-kcm = callPackage ./sddm-kcm.nix { };
      systemsettings = callPackage ./systemsettings.nix { };
      xdg-desktop-portal-kde = callPackage ./xdg-desktop-portal-kde.nix { };

      thirdParty = let inherit (libsForQt5) callPackage; in {
        plasma-applet-caffeine-plus = callPackage ./3rdparty/addons/caffeine-plus.nix { };
        plasma-applet-virtual-desktop-bar = callPackage ./3rdparty/addons/virtual-desktop-bar.nix { };
        bismuth = callPackage ./3rdparty/addons/bismuth { };
        kwin-dynamic-workspaces = callPackage ./3rdparty/kwin/scripts/dynamic-workspaces.nix { };
        kwin-tiling = callPackage ./3rdparty/kwin/scripts/tiling.nix { };
        krohnkite = callPackage ./3rdparty/kwin/scripts/krohnkite.nix { };
        krunner-ssh = callPackage ./3rdparty/addons/krunner-ssh.nix { };
        krunner-symbols = callPackage ./3rdparty/addons/krunner-symbols.nix { };
        kzones = callPackage ./3rdparty/kwin/scripts/kzones.nix { };
        lightly = callPackage ./3rdparty/lightly { };
        parachute = callPackage ./3rdparty/kwin/scripts/parachute.nix { };
        polonium = callPackage ./3rdparty/addons/polonium.nix { };
      };

    } // lib.optionalAttrs config.allowAliases {
      ksysguard = throw "ksysguard has been replaced with plasma-systemmonitor";
      plasma-phone-components = throw "'plasma-phone-components' has been renamed to/replaced by 'plasma-mobile'";
    };
in
lib.makeScope libsForQt5.newScope packages
