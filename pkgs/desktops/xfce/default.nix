{ config, lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {
  #### NixOS support

  updateScript = pkgs.genericUpdater;

  gitLister = url:
    "${pkgs.common-updater-scripts}/bin/list-git-tags ${url}";

  archiveLister = category: name:
    "${pkgs.common-updater-scripts}/bin/list-archive-two-level-versions https://archive.xfce.org/src/${category}/${name}";

  mkXfceDerivation = callPackage ./mkXfceDerivation.nix { };

  automakeAddFlags = pkgs.makeSetupHook { } ./automakeAddFlags.sh;

  # Samba is a rather heavy dependency
  gvfs = pkgs.gvfs.override { samba = null; };

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

  xfce4-screenshooter = callPackage ./applications/xfce4-screenshooter {
    inherit (pkgs.gnome3) libsoup;
  };

  xfdashboard = callPackage ./applications/xfdashboard {};

  # TODO: this repo is inactive for many years. Remove?
  xfce4-volumed = callPackage ./applications/xfce4-volumed { };

  xfce4-volumed-pulse = callPackage ./applications/xfce4-volumed-pulse { };

  xfce4-notifyd = callPackage ./applications/xfce4-notifyd { };

  xfburn = callPackage ./applications/xfburn { };

  #### ART

  xfce4-icon-theme = callPackage ./art/xfce4-icon-theme.nix { };

  xfwm4-themes = callPackage ./art/xfwm4-themes.nix { };

  #### PANEL PLUGINS

  xfce4-vala-panel-appmenu-plugin = callPackage ./panel-plugins/xfce4-vala-panel-appmenu-plugin { };

  xfce4-battery-plugin = callPackage ./panel-plugins/xfce4-battery-plugin { };

  xfce4-clipman-plugin = callPackage ./panel-plugins/xfce4-clipman-plugin { };

  xfce4-cpufreq-plugin = callPackage ./panel-plugins/xfce4-cpufreq-plugin { };

  xfce4-cpugraph-plugin = callPackage ./panel-plugins/xfce4-cpugraph-plugin.nix { };

  xfce4-datetime-plugin = callPackage ./panel-plugins/xfce4-datetime-plugin { };

  xfce4-dockbarx-plugin = callPackage ./panel-plugins/xfce4-dockbarx-plugin.nix { };

  xfce4-embed-plugin = callPackage ./panel-plugins/xfce4-embed-plugin.nix { };

  xfce4-eyes-plugin = callPackage ./panel-plugins/xfce4-eyes-plugin.nix { };

  xfce4-fsguard-plugin = callPackage ./panel-plugins/xfce4-fsguard-plugin.nix { };

  xfce4-genmon-plugin = callPackage ./panel-plugins/xfce4-genmon-plugin.nix { };

  xfce4-hardware-monitor-plugin = callPackage ./panel-plugins/xfce4-hardware-monitor-plugin.nix { };

  xfce4-namebar-plugin = callPackage ./panel-plugins/xfce4-namebar-plugin.nix { };

  xfce4-netload-plugin = callPackage ./panel-plugins/xfce4-netload-plugin { };

  xfce4-notes-plugin = callPackage ./panel-plugins/xfce4-notes-plugin.nix { };

  xfce4-mailwatch-plugin = callPackage ./panel-plugins/xfce4-mailwatch-plugin.nix { };

  xfce4-mpc-plugin = callPackage ./panel-plugins/xfce4-mpc-plugin.nix { };

  xfce4-sensors-plugin = callPackage ./panel-plugins/xfce4-sensors-plugin.nix { };

  xfce4-systemload-plugin = callPackage ./panel-plugins/xfce4-systemload-plugin.nix { };

  xfce4-timer-plugin = callPackage ./panel-plugins/xfce4-timer-plugin.nix { };

  xfce4-verve-plugin = callPackage ./panel-plugins/xfce4-verve-plugin { };

  xfce4-xkb-plugin = callPackage ./panel-plugins/xfce4-xkb-plugin { };

  xfce4-weather-plugin = callPackage ./panel-plugins/xfce4-weather-plugin.nix { };

  xfce4-whiskermenu-plugin = callPackage ./panel-plugins/xfce4-whiskermenu-plugin { };

  xfce4-windowck-plugin = callPackage ./panel-plugins/xfce4-windowck-plugin.nix { };

  xfce4-pulseaudio-plugin = callPackage ./panel-plugins/xfce4-pulseaudio-plugin { };

} // lib.optionalAttrs (config.allowAliases or true) {
  #### ALIASES - added 2018-01

  terminal = xfce4-terminal;
  thunar-build = thunar-bare;
  thunarx-2-dev = thunar-build;
  thunar_volman = thunar-volman;
  xfce4panel = xfce4-panel;
  xfce4session = xfce4-session;
  xfce4settings = xfce4-settings;
  xfce4_power_manager = xfce4-power-manager;
  xfce4_appfinder = xfce4-appfinder;
  xfce4_dev_tools = xfce4-dev-tools;
  xfce4mixer = xfce4-mixer;
  xfce4mixer_pulse = xfce4-mixer-pulse;
  xfce4notifyd = xfce4-notifyd;
  xfce4taskmanager = xfce4-taskmanager;
  xfce4terminal = xfce4-terminal;
  xfce4volumed = xfce4-volumed;
  xfce4volumed_pulse = xfce4-volumed-pulse;
  xfce4icontheme = xfce4-icon-theme;
  xfwm4themes = xfwm4-themes;

  xfce4_battery_plugin = xfce4-battery-plugin;
  xfce4_clipman_plugin = xfce4-clipman-plugin;
  xfce4_cpufreq_plugin = xfce4-cpufreq-plugin;
  xfce4_cpugraph_plugin = xfce4-cpugraph-plugin;
  xfce4_datetime_plugin = xfce4-datetime-plugin;
  xfce4_dockbarx_plugin = xfce4-dockbarx-plugin;
  xfce4_embed_plugin = xfce4-embed-plugin;
  xfce4_eyes_plugin = xfce4-eyes-plugin;
  xfce4_fsguard_plugin = xfce4-fsguard-plugin;
  xfce4_genmon_plugin = xfce4-genmon-plugin;
  xfce4_hardware_monitor_plugin = xfce4-hardware-monitor-plugin;
  xfce4_namebar_plugin = xfce4-namebar-plugin;
  xfce4_netload_plugin = xfce4-netload-plugin;
  xfce4_notes_plugin = xfce4-notes-plugin;
  xfce4_mailwatch_plugin = xfce4-mailwatch-plugin;
  xfce4_mpc_plugin = xfce4-mpc-plugin;
  xfce4_sensors_plugin = xfce4-sensors-plugin;
  xfce4_systemload_plugin = xfce4-systemload-plugin;
  xfce4_timer_plugin = xfce4-timer-plugin;
  xfce4_verve_plugin = xfce4-verve-plugin;
  xfce4_xkb_plugin = xfce4-xkb-plugin;
  xfce4_weather_plugin = xfce4-weather-plugin;
  xfce4_whiskermenu_plugin = xfce4-whiskermenu-plugin;
  xfce4_windowck_plugin = xfce4-windowck-plugin;
  xfce4_pulseaudio_plugin = xfce4-pulseaudio-plugin;

  xfce4-mixer = throw "deprecated 2019-08-18: obsoleted by xfce4-pulseaudio-plugin"; # added 2019-08-18
  gtk-xfce-engine = throw "deprecated 2019-09-17: Xfce 4.14 deprecated gtk-xfce-engine"; # added 2019-09-17
  xfce4-dict-plugin = throw "deprecated 2020-04-19: xfce4-dict-plugin is now part of xfce4-dict."; # added 2020-04-19

  # added 2019-11-04
  libxfce4ui_gtk3 = libxfce4ui;
  xfce4panel_gtk3 = xfce4-panel;
  xfce4_power_manager_gtk3 = xfce4-power-manager;
  gtk = pkgs.gtk2;
  libxfcegui4 = throw "libxfcegui4 is the deprecated Xfce GUI library. It has been superseded by the libxfce4ui library";
  xinitrc = xfce4-session.xinitrc;
  inherit (pkgs.gnome2) libglade;
  inherit (pkgs.gnome3) vte gtksourceview;
  xfce4-mixer-pulse = xfce4-mixer;
  thunar-bare = thunar.override {
    thunarPlugins = [];
  };

  # added 2019-11-30
  inherit (pkgs) dconf;
})
