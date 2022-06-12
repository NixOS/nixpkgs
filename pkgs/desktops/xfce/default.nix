{ config, lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {
  #### NixOS support

  genericUpdater = pkgs.genericUpdater;

  archiveUpdater = { category, pname, version }:
    pkgs.httpTwoLevelsUpdater {
      inherit pname version;
      attrPath = "xfce.${pname}";
      url = "https://archive.xfce.org/src/${category}/${pname}";
    };

  mkXfceDerivation = callPackage ./mkXfceDerivation.nix { };

  automakeAddFlags = pkgs.makeSetupHook { } ./automakeAddFlags.sh;

  #### CORE

  exo = callPackage ./core/exo { };

  garcon = callPackage ./core/garcon { };

  libxfce4ui = callPackage ./core/libxfce4ui { };

  libxfce4util = callPackage ./core/libxfce4util { };

  thunar = callPackage ./core/thunar {
    thunarPlugins = [];
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
    mkXfceDerivation = mkXfceDerivation.override {
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

  xfce4-screenshooter = callPackage ./applications/xfce4-screenshooter {
    inherit (pkgs.gnome) libsoup;
  };

  xfdashboard = callPackage ./applications/xfdashboard {};

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

  xfce4-embed-plugin = callPackage ./panel-plugins/xfce4-embed-plugin { };

  xfce4-eyes-plugin = callPackage ./panel-plugins/xfce4-eyes-plugin { };

  xfce4-fsguard-plugin = callPackage ./panel-plugins/xfce4-fsguard-plugin { };

  xfce4-genmon-plugin = callPackage ./panel-plugins/xfce4-genmon-plugin { };

  xfce4-hardware-monitor-plugin = callPackage ./panel-plugins/xfce4-hardware-monitor-plugin { };

  xfce4-i3-workspaces-plugin = callPackage ./panel-plugins/xfce4-i3-workspaces-plugin { };

  xfce4-namebar-plugin = callPackage ./panel-plugins/xfce4-namebar-plugin { };

  xfce4-netload-plugin = callPackage ./panel-plugins/xfce4-netload-plugin { };

  xfce4-notes-plugin = callPackage ./panel-plugins/xfce4-notes-plugin { };

  xfce4-mailwatch-plugin = callPackage ./panel-plugins/xfce4-mailwatch-plugin { };

  xfce4-mpc-plugin = callPackage ./panel-plugins/xfce4-mpc-plugin { };

  xfce4-sensors-plugin = callPackage ./panel-plugins/xfce4-sensors-plugin { };

  xfce4-systemload-plugin = callPackage ./panel-plugins/xfce4-systemload-plugin { };

  xfce4-timer-plugin = callPackage ./panel-plugins/xfce4-timer-plugin { };

  xfce4-verve-plugin = callPackage ./panel-plugins/xfce4-verve-plugin { };

  xfce4-xkb-plugin = callPackage ./panel-plugins/xfce4-xkb-plugin { };

  xfce4-weather-plugin = callPackage ./panel-plugins/xfce4-weather-plugin { };

  xfce4-whiskermenu-plugin = callPackage ./panel-plugins/xfce4-whiskermenu-plugin { };

  xfce4-windowck-plugin = callPackage ./panel-plugins/xfce4-windowck-plugin { };

  xfce4-pulseaudio-plugin = callPackage ./panel-plugins/xfce4-pulseaudio-plugin { };

} // lib.optionalAttrs config.allowAliases {
  #### ALIASES

  xinitrc = xfce4-session.xinitrc; # added 2019-11-04

  thunar-bare = thunar.override { thunarPlugins = []; };  # added 2019-11-04

}) // lib.optionalAttrs config.allowAliases {
  #### Legacy aliases. They need to be outside the scope or they will shadow the attributes from parent scope.

  terminal = throw "xfce.terminal has been removed, use xfce.xfce4-terminal instead"; # added 2022-05-24
  thunar-build = throw "xfce.thunar-build has been removed, use xfce.thunar-bare instead"; # added 2022-05-24
  thunarx-2-dev = throw "xfce.thunarx-2-dev has been removed, use xfce.thunar-bare instead"; # added 2022-05-24
  thunar_volman = throw "xfce.thunar_volman has been removed, use xfce.thunar-volman instead"; # added 2022-05-24
  xfce4panel = throw "xfce.xfce4panel has been removed, use xfce.xfce4-panel instead"; # added 2022-05-24
  xfce4session = throw "xfce.xfce4session has been removed, use xfce.xfce4-session instead"; # added 2022-05-24
  xfce4settings = throw "xfce.xfce4settings has been removed, use xfce.xfce4-settings instead"; # added 2022-05-24
  xfce4_power_manager = throw "xfce.xfce4_power_manager has been removed, use xfce.xfce4-power-manager instead"; # added 2022-05-24
  xfce4_appfinder = throw "xfce.xfce4_appfinder has been removed, use xfce.xfce4-appfinder instead"; # added 2022-05-24
  xfce4_dev_tools = throw "xfce.xfce4_dev_tools has been removed, use xfce.xfce4-dev-tools instead"; # added 2022-05-24
  xfce4notifyd = throw "xfce.xfce4notifyd has been removed, use xfce.xfce4-notifyd instead"; # added 2022-05-24
  xfce4taskmanager = throw "xfce.xfce4taskmanager has been removed, use xfce.xfce4-taskmanager instead"; # added 2022-05-24
  xfce4terminal = throw "xfce.xfce4terminal has been removed, use xfce.xfce4-terminal instead"; # added 2022-05-24
  xfce4volumed_pulse = throw "xfce.xfce4volumed_pulse has been removed, use xfce.xfce4-volumed-pulse instead"; # added 2022-05-24
  xfce4icontheme = throw "xfce.xfce4icontheme has been removed, use xfce.xfce4-icon-theme instead"; # added 2022-05-24
  xfwm4themes = throw "xfce.xfwm4themes has been removed, use xfce.xfwm4-themes instead"; # added 2022-05-24
  xfce4_battery_plugin = throw "xfce.xfce4_battery_plugin has been removed, use xfce.xfce4-battery-plugin instead"; # added 2022-05-24
  xfce4_clipman_plugin = throw "xfce.xfce4_clipman_plugin has been removed, use xfce.xfce4-clipman-plugin instead"; # added 2022-05-24
  xfce4_cpufreq_plugin = throw "xfce.xfce4_cpufreq_plugin has been removed, use xfce.xfce4-cpufreq-plugin instead"; # added 2022-05-24
  xfce4_cpugraph_plugin = throw "xfce.xfce4_cpugraph_plugin has been removed, use xfce.xfce4-cpugraph-plugin instead"; # added 2022-05-24
  xfce4_datetime_plugin = throw "xfce.xfce4_datetime_plugin has been removed, use xfce.xfce4-datetime-plugin instead"; # added 2022-05-24
  xfce4_dockbarx_plugin = throw "xfce.xfce4_dockbarx_plugin has been removed, use xfce.xfce4-dockbarx-plugin instead"; # added 2022-05-24
  xfce4_embed_plugin = throw "xfce.xfce4_embed_plugin has been removed, use xfce.xfce4-embed-plugin instead"; # added 2022-05-24
  xfce4_eyes_plugin = throw "xfce.xfce4_eyes_plugin has been removed, use xfce.xfce4-eyes-plugin instead"; # added 2022-05-24
  xfce4_fsguard_plugin = throw "xfce.xfce4_fsguard_plugin has been removed, use xfce.xfce4-fsguard-plugin instead"; # added 2022-05-24
  xfce4_genmon_plugin = throw "xfce.xfce4_genmon_plugin has been removed, use xfce.xfce4-genmon-plugin instead"; # added 2022-05-24
  xfce4_hardware_monitor_plugin = throw "xfce.xfce4_hardware_monitor_plugin has been removed, use xfce.xfce4-hardware-monitor-plugin instead"; # added 2022-05-24
  xfce4_namebar_plugin = throw "xfce.xfce4_namebar_plugin has been removed, use xfce.xfce4-namebar-plugin instead"; # added 2022-05-24
  xfce4_netload_plugin = throw "xfce.xfce4_netload_plugin has been removed, use xfce.xfce4-netload-plugin instead"; # added 2022-05-24
  xfce4_notes_plugin = throw "xfce.xfce4_notes_plugin has been removed, use xfce.xfce4-notes-plugin instead"; # added 2022-05-24
  xfce4_mailwatch_plugin = throw "xfce.xfce4_mailwatch_plugin has been removed, use xfce.xfce4-mailwatch-plugin instead"; # added 2022-05-24
  xfce4_mpc_plugin = throw "xfce.xfce4_mpc_plugin has been removed, use xfce.xfce4-mpc-plugin instead"; # added 2022-05-24
  xfce4_sensors_plugin = throw "xfce.xfce4_sensors_plugin has been removed, use xfce.xfce4-sensors-plugin instead"; # added 2022-05-24
  xfce4_systemload_plugin = throw "xfce.xfce4_systemload_plugin has been removed, use xfce.xfce4-systemload-plugin instead"; # added 2022-05-24
  xfce4_timer_plugin = throw "xfce.xfce4_timer_plugin has been removed, use xfce.xfce4-timer-plugin instead"; # added 2022-05-24
  xfce4_verve_plugin = throw "xfce.xfce4_verve_plugin has been removed, use xfce.xfce4-verve-plugin instead"; # added 2022-05-24
  xfce4_xkb_plugin = throw "xfce.xfce4_xkb_plugin has been removed, use xfce.xfce4-xkb-plugin instead"; # added 2022-05-24
  xfce4_weather_plugin = throw "xfce.xfce4_weather_plugin has been removed, use xfce.xfce4-weather-plugin instead"; # added 2022-05-24
  xfce4_whiskermenu_plugin = throw "xfce.xfce4_whiskermenu_plugin has been removed, use xfce.xfce4-whiskermenu-plugin instead"; # added 2022-05-24
  xfce4_windowck_plugin = throw "xfce.xfce4_windowck_plugin has been removed, use xfce.xfce4-windowck-plugin instead"; # added 2022-05-24
  xfce4_pulseaudio_plugin = throw "xfce.xfce4_pulseaudio_plugin has been removed, use xfce.xfce4-pulseaudio-plugin instead"; # added 2022-05-24
  libxfce4ui_gtk3 = throw "xfce.libxfce4ui_gtk3 has been removed, use xfce.libxfce4ui instead"; # added 2022-05-24
  xfce4panel_gtk3 = throw "xfce.xfce4panel_gtk3 has been removed, use xfce.xfce4-panel instead"; # added 2022-05-24
  xfce4_power_manager_gtk3 = throw "xfce.xfce4_power_manager_gtk3 has been removed, use xfce.xfce4-power-manager instead"; # added 2022-05-24
  gtk = throw "xfce.gtk has been removed, use gtk2 instead"; # added 2022-05-24
  gtksourceview = throw "xfce.gtksourceview has been removed, use gtksourceview instead"; # added 2022-05-24
  dconf = throw "xfce.dconf has been removed, use dconf instead"; # added 2022-05-24
  vte = throw "xfce.vte has been removed, use vte instead"; # added 2022-05-24
}
