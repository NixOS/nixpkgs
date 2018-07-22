{ config, lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {
  #### NixOS support

  inherit (pkgs.gnome2) libglade libwnck vte gtksourceview;
  inherit (pkgs.gnome3) dconf;
  inherit (pkgs.perlPackages) URI;

  gtk = pkgs.gtk2;

  # Samba is a rather heavy dependency
  gvfs = pkgs.gvfs.override { samba = null; };

  xinitrc = "${xfce4-session}/etc/xdg/xfce4/xinitrc";

  #### CORE

  exo = callPackage ./core/exo.nix { };

  garcon = callPackage ./core/garcon.nix { };

  # When built with GTK+3, it was breaking GTK+3 app layout
  gtk-xfce-engine = callPackage ./core/gtk-xfce-engine.nix { withGtk3 = false; };

  libxfce4ui = callPackage ./core/libxfce4ui.nix { };

  libxfce4util = callPackage ./core/libxfce4util.nix { };

  libxfcegui4 = callPackage ./core/libxfcegui4.nix { };

  thunar-bare = callPackage ./core/thunar-build.nix { };

  thunar = callPackage ./core/thunar.nix { };

  # NB: thunar already has it
  thunar-volman = callPackage ./core/thunar-volman.nix { };

  thunar-archive-plugin = callPackage ./thunar-plugins/archive { };

  thunar-dropbox-plugin = callPackage ./thunar-plugins/dropbox { };

  tumbler = callPackage ./core/tumbler.nix { };

  # TODO: impure plugins from /run/current-system/sw/lib/xfce4
  xfce4-panel = callPackage ./core/xfce4-panel.nix { };

  xfce4-session = callPackage ./core/xfce4-session.nix { };

  xfce4-settings = callPackage ./core/xfce4-settings.nix { };

  xfce4-power-manager = callPackage ./core/xfce4-power-manager.nix { };

  xfconf = callPackage ./core/xfconf.nix { };

  xfdesktop = callPackage ./core/xfdesktop.nix { };

  xfwm4 = callPackage ./core/xfwm4.nix { };

  xfce4-appfinder = callPackage ./core/xfce4-appfinder.nix { };

  xfce4-dev-tools = callPackage ./core/xfce4-dev-tools.nix { };

  #### APPLICATIONS

  gigolo = callPackage ./applications/gigolo.nix { };

  mousepad = callPackage ./applications/mousepad.nix { };

  orage = callPackage ./applications/orage.nix { };

  parole = callPackage ./applications/parole.nix { };

  ristretto = callPackage ./applications/ristretto.nix { };

  xfce4-mixer = callPackage ./applications/xfce4-mixer.nix { };

  xfce4-mixer-pulse = callPackage ./applications/xfce4-mixer.nix { pulseaudioSupport = true; };

  xfce4-notifyd = callPackage ./applications/xfce4-notifyd.nix { };

  xfce4-taskmanager = callPackage ./applications/xfce4-taskmanager.nix { };

  xfce4-terminal = callPackage ./applications/terminal.nix { };

  xfce4-screenshooter = callPackage ./applications/xfce4-screenshooter.nix { };

  xfce4-volumed = callPackage ./applications/xfce4-volumed.nix { };

  xfce4-volumed-pulse = callPackage ./applications/xfce4-volumed-pulse.nix { };

  #### ART

  xfce4-icon-theme = callPackage ./art/xfce4-icon-theme.nix { };

  xfwm4-themes = callPackage ./art/xfwm4-themes.nix { };

  #### PANEL PLUGINS

  xfce4-vala-panel-appmenu-plugin = callPackage ./panel-plugins/xfce4-vala-panel-appmenu-plugin { };

  xfce4-battery-plugin = callPackage ./panel-plugins/xfce4-battery-plugin.nix { };

  xfce4-clipman-plugin = callPackage ./panel-plugins/xfce4-clipman-plugin.nix { };

  xfce4-cpufreq-plugin = callPackage ./panel-plugins/xfce4-cpufreq-plugin.nix { };

  xfce4-cpugraph-plugin = callPackage ./panel-plugins/xfce4-cpugraph-plugin.nix { };

  xfce4-datetime-plugin = callPackage ./panel-plugins/xfce4-datetime-plugin.nix { };

  xfce4-dict-plugin = callPackage ./panel-plugins/xfce4-dict-plugin.nix { };

  xfce4-dockbarx-plugin = callPackage ./panel-plugins/xfce4-dockbarx-plugin.nix { };

  xfce4-embed-plugin = callPackage ./panel-plugins/xfce4-embed-plugin.nix { };

  xfce4-eyes-plugin = callPackage ./panel-plugins/xfce4-eyes-plugin.nix { };

  xfce4-fsguard-plugin = callPackage ./panel-plugins/xfce4-fsguard-plugin.nix { };

  xfce4-genmon-plugin = callPackage ./panel-plugins/xfce4-genmon-plugin.nix { };

  xfce4-hardware-monitor-plugin = callPackage ./panel-plugins/xfce4-hardware-monitor-plugin.nix { };

  xfce4-namebar-plugin = callPackage ./panel-plugins/xfce4-namebar-plugin.nix { };

  xfce4-netload-plugin = callPackage ./panel-plugins/xfce4-netload-plugin.nix { };

  xfce4-notes-plugin = callPackage ./panel-plugins/xfce4-notes-plugin.nix { };

  xfce4-mailwatch-plugin = callPackage ./panel-plugins/xfce4-mailwatch-plugin.nix { };

  xfce4-mpc-plugin = callPackage ./panel-plugins/xfce4-mpc-plugin.nix { };

  xfce4-sensors-plugin = callPackage ./panel-plugins/xfce4-sensors-plugin.nix { };

  xfce4-systemload-plugin = callPackage ./panel-plugins/xfce4-systemload-plugin.nix { };

  xfce4-timer-plugin = callPackage ./panel-plugins/xfce4-timer-plugin.nix { };

  xfce4-verve-plugin = callPackage ./panel-plugins/xfce4-verve-plugin.nix { };

  xfce4-xkb-plugin = callPackage ./panel-plugins/xfce4-xkb-plugin.nix { };

  xfce4-weather-plugin = callPackage ./panel-plugins/xfce4-weather-plugin.nix { };

  xfce4-whiskermenu-plugin = callPackage ./panel-plugins/xfce4-whiskermenu-plugin.nix { };

  xfce4-windowck-plugin = callPackage ./panel-plugins/xfce4-windowck-plugin.nix { };

  xfce4-pulseaudio-plugin = callPackage ./panel-plugins/xfce4-pulseaudio-plugin.nix { };

  #### GTK+3 (deprecated, see NixOS/nixpkgs#32763)

  libxfce4ui_gtk3 = libxfce4ui.override { withGtk3 = true; };

  xfce4panel_gtk3 = xfce4-panel.override { withGtk3 = true; };

  xfce4_power_manager_gtk3 = xfce4-power-manager.override { withGtk3 = true; };

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
  xfce4_dict_plugin = xfce4-dict-plugin;
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
})
