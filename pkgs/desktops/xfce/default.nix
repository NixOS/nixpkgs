{ config
, lib
, pkgs
, generateSplicesForMkScope
, makeScopeWithSplicing'
}:

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "xfce";
  f = (self:
    let
      inherit (self) callPackage;
    in
    {
      #### NixOS support

      genericUpdater = pkgs.genericUpdater;

      mkXfceDerivation = callPackage ./mkXfceDerivation.nix { };

      #### CORE

      exo = callPackage ./core/exo { };

      garcon = callPackage ./core/garcon { };

      libxfce4ui = callPackage ./core/libxfce4ui { };

      libxfce4util = callPackage ./core/libxfce4util { };

      libxfce4windowing = callPackage ./core/libxfce4windowing { };

      thunar = callPackage ./core/thunar {
        thunarPlugins = [ ];
      };

      thunar-volman = callPackage ./core/thunar-volman { };

      thunar-archive-plugin = callPackage ./thunar-plugins/archive { };

      thunar-dropbox-plugin = callPackage ./thunar-plugins/dropbox { };

      thunar-media-tags-plugin = callPackage ./thunar-plugins/media-tags { };

      tumbler = callPackage ./core/tumbler { };

      xfce4-panel = callPackage ./core/xfce4-panel { };

      xfce4-session = callPackage ./core/xfce4-session { };

      xfce4-settings = callPackage ./core/xfce4-settings { };

      xfce4-power-manager = callPackage ./core/xfce4-power-manager { };

      xfconf = callPackage ./core/xfconf { };

      xfdesktop = callPackage ./core/xfdesktop { };

      xfwm4 = callPackage ./core/xfwm4 { };

      xfce4-appfinder = callPackage ./core/xfce4-appfinder { };

      xfce4-dev-tools = callPackage ./core/xfce4-dev-tools {
        mkXfceDerivation = self.mkXfceDerivation.override {
          xfce4-dev-tools = null;
        };
      };

      #### APPLICATIONS

      catfish = callPackage ./applications/catfish { };

      gigolo = callPackage ./applications/gigolo { };

      mousepad = callPackage ./applications/mousepad { };

      orage = callPackage ./applications/orage { };

      parole = callPackage ./applications/parole { };

      ristretto = callPackage ./applications/ristretto { };

      xfce4-taskmanager = callPackage ./applications/xfce4-taskmanager { };

      xfce4-dict = callPackage ./applications/xfce4-dict { };

      xfce4-terminal = callPackage ./applications/xfce4-terminal { };

      xfce4-screensaver = callPackage ./applications/xfce4-screensaver { };

      xfce4-screenshooter = callPackage ./applications/xfce4-screenshooter { };

      xfdashboard = callPackage ./applications/xfdashboard { };

      xfce4-volumed-pulse = callPackage ./applications/xfce4-volumed-pulse { };

      xfce4-notifyd = callPackage ./applications/xfce4-notifyd { };

      xfburn = callPackage ./applications/xfburn { };

      xfce4-panel-profiles = callPackage ./applications/xfce4-panel-profiles { };

      #### ART

      xfce4-icon-theme = callPackage ./art/xfce4-icon-theme { };

      xfwm4-themes = callPackage ./art/xfwm4-themes { };

      #### PANEL PLUGINS

      xfce4-battery-plugin = callPackage ./panel-plugins/xfce4-battery-plugin { };

      xfce4-clipman-plugin = callPackage ./panel-plugins/xfce4-clipman-plugin { };

      xfce4-cpufreq-plugin = callPackage ./panel-plugins/xfce4-cpufreq-plugin { };

      xfce4-cpugraph-plugin = callPackage ./panel-plugins/xfce4-cpugraph-plugin { };

      xfce4-datetime-plugin = callPackage ./panel-plugins/xfce4-datetime-plugin { };

      xfce4-dockbarx-plugin = callPackage ./panel-plugins/xfce4-dockbarx-plugin { };

      xfce4-docklike-plugin = callPackage ./panel-plugins/xfce4-docklike-plugin { };

      xfce4-embed-plugin = callPackage ./panel-plugins/xfce4-embed-plugin { };

      xfce4-eyes-plugin = callPackage ./panel-plugins/xfce4-eyes-plugin { };

      xfce4-fsguard-plugin = callPackage ./panel-plugins/xfce4-fsguard-plugin { };

      xfce4-genmon-plugin = callPackage ./panel-plugins/xfce4-genmon-plugin { };

      xfce4-i3-workspaces-plugin = callPackage ./panel-plugins/xfce4-i3-workspaces-plugin { };

      xfce4-netload-plugin = callPackage ./panel-plugins/xfce4-netload-plugin { };

      xfce4-notes-plugin = callPackage ./panel-plugins/xfce4-notes-plugin { };

      xfce4-mailwatch-plugin = callPackage ./panel-plugins/xfce4-mailwatch-plugin { };

      xfce4-mpc-plugin = callPackage ./panel-plugins/xfce4-mpc-plugin { };

      xfce4-sensors-plugin = callPackage ./panel-plugins/xfce4-sensors-plugin { };

      xfce4-systemload-plugin = callPackage ./panel-plugins/xfce4-systemload-plugin { };

      xfce4-time-out-plugin = callPackage ./panel-plugins/xfce4-time-out-plugin { };

      xfce4-timer-plugin = callPackage ./panel-plugins/xfce4-timer-plugin { };

      xfce4-verve-plugin = callPackage ./panel-plugins/xfce4-verve-plugin { };

      xfce4-xkb-plugin = callPackage ./panel-plugins/xfce4-xkb-plugin { };

      xfce4-weather-plugin = callPackage ./panel-plugins/xfce4-weather-plugin { };

      xfce4-whiskermenu-plugin = callPackage ./panel-plugins/xfce4-whiskermenu-plugin { };

      xfce4-windowck-plugin = callPackage ./panel-plugins/xfce4-windowck-plugin { };

      xfce4-pulseaudio-plugin = callPackage ./panel-plugins/xfce4-pulseaudio-plugin { };

    } // lib.optionalAttrs config.allowAliases {
      #### ALIASES

      automakeAddFlags = throw "xfce.automakeAddFlags has been removed: this setup-hook is no longer used in Nixpkgs"; # added 2024-03-24

      xinitrc = self.xfce4-session.xinitrc; # added 2019-11-04

      thunar-bare = self.thunar.override { thunarPlugins = [ ]; }; # added 2019-11-04

      xfce4-hardware-monitor-plugin = throw "xfce.xfce4-hardware-monitor-plugin has been removed: abandoned by upstream and does not build"; # added 2023-01-15
      xfce4-namebar-plugin = throw "xfce.xfce4-namebar-plugin has been removed: abandoned by upstream and does not build"; # added 2024-05-08
    });
}
