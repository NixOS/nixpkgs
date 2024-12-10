{ pkgs, lib }:

let
  packages =
    self: with self; {

      # Update script tailored to mate packages from git repository
      mateUpdateScript =
        {
          pname,
          odd-unstable ? true,
          rev-prefix ? "v",
          url ? null,
        }:
        pkgs.gitUpdater {
          inherit odd-unstable rev-prefix;
          url = if url == null then "https://git.mate-desktop.org/${pname}" else url;
        };

      atril = callPackage ./atril { };
      caja = callPackage ./caja { };
      caja-dropbox = callPackage ./caja-dropbox { };
      caja-extensions = callPackage ./caja-extensions { };
      caja-with-extensions = callPackage ./caja/with-extensions.nix { };
      engrampa = callPackage ./engrampa { };
      eom = callPackage ./eom { };
      libmatekbd = callPackage ./libmatekbd { };
      libmatemixer = callPackage ./libmatemixer { };
      libmateweather = callPackage ./libmateweather { };
      marco = callPackage ./marco { };
      mate-applets = callPackage ./mate-applets { };
      mate-backgrounds = callPackage ./mate-backgrounds { };
      mate-calc = callPackage ./mate-calc { };
      mate-common = callPackage ./mate-common { };
      mate-control-center = callPackage ./mate-control-center { };
      mate-desktop = callPackage ./mate-desktop { };
      mate-gsettings-overrides = callPackage ./mate-gsettings-overrides { };
      mate-icon-theme = callPackage ./mate-icon-theme { };
      mate-icon-theme-faenza = callPackage ./mate-icon-theme-faenza { };
      mate-indicator-applet = callPackage ./mate-indicator-applet { };
      mate-media = callPackage ./mate-media { };
      mate-menus = callPackage ./mate-menus { };
      mate-netbook = callPackage ./mate-netbook { };
      mate-notification-daemon = callPackage ./mate-notification-daemon { };
      mate-panel = callPackage ./mate-panel { };
      mate-panel-with-applets = callPackage ./mate-panel/with-applets.nix { };
      mate-polkit = callPackage ./mate-polkit { };
      mate-power-manager = callPackage ./mate-power-manager { };
      mate-sensors-applet = callPackage ./mate-sensors-applet { };
      mate-session-manager = callPackage ./mate-session-manager { };
      mate-settings-daemon = callPackage ./mate-settings-daemon { };
      mate-settings-daemon-wrapped = callPackage ./mate-settings-daemon/wrapped.nix { };
      mate-screensaver = callPackage ./mate-screensaver { };
      mate-system-monitor = callPackage ./mate-system-monitor { };
      mate-terminal = callPackage ./mate-terminal { };
      mate-themes = callPackage ./mate-themes { };
      mate-tweak = callPackage ./mate-tweak { };
      mate-user-guide = callPackage ./mate-user-guide { };
      mate-user-share = callPackage ./mate-user-share { };
      mate-utils = callPackage ./mate-utils { };
      mate-wayland-session = callPackage ./mate-wayland-session { };
      mozo = callPackage ./mozo { };
      pluma = callPackage ./pluma { };
      python-caja = callPackage ./python-caja { };

      # Caja and mate-panel are managed in NixOS module.
      basePackages = [
        libmatekbd
        libmatemixer
        libmateweather
        marco
        mate-common
        mate-control-center
        mate-desktop
        mate-icon-theme
        mate-menus
        mate-notification-daemon
        mate-polkit
        mate-session-manager
        mate-settings-daemon
        mate-settings-daemon-wrapped
        mate-themes
      ];

      extraPackages = [
        atril
        caja-extensions # for caja-sendto
        engrampa
        eom
        mate-applets
        mate-backgrounds
        mate-calc
        mate-indicator-applet
        mate-media
        mate-netbook
        mate-power-manager
        mate-screensaver
        mate-system-monitor
        mate-terminal
        mate-user-guide
        # mate-user-share
        mate-utils
        mozo
        pluma
      ];

      cajaExtensions = [
        caja-extensions
      ];

      panelApplets = [
        mate-applets
        mate-indicator-applet
        mate-netbook
        mate-notification-daemon
        mate-media
        mate-power-manager
        mate-sensors-applet
        mate-utils
      ];
    };

in
lib.makeScope pkgs.newScope packages
