{
  config,
  lib,
  linuxPackages,
  pkgs,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
}:

makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "xfce";
  f = (
    self:
    let
      inherit (self) callPackage;
    in
    {
      #### CORE

      thunar-unwrapped = callPackage ./core/thunar { };

      thunar = callPackage ./core/thunar/wrapper.nix { };

      thunar-volman = callPackage ./core/thunar-volman { };

      thunar-archive-plugin = callPackage ./thunar-plugins/archive { };

      thunar-dropbox-plugin = callPackage ./thunar-plugins/dropbox { };

      thunar-media-tags-plugin = callPackage ./thunar-plugins/media-tags { };

      thunar-vcs-plugin = callPackage ./thunar-plugins/vcs { };

      tumbler = callPackage ./core/tumbler { };

      xfce4-session = callPackage ./core/xfce4-session { };

      xfce4-settings = callPackage ./core/xfce4-settings { };

      xfce4-power-manager = callPackage ./core/xfce4-power-manager { };

      xfdesktop = callPackage ./core/xfdesktop { };

      xfwm4 = callPackage ./core/xfwm4 { };

      xfce4-appfinder = callPackage ./core/xfce4-appfinder { };

      #### APPLICATIONS

      catfish = callPackage ./applications/catfish { };

      gigolo = callPackage ./applications/gigolo { };

      mousepad = callPackage ./applications/mousepad { };

      orage = callPackage ./applications/orage { };

      parole = callPackage ./applications/parole { };

      ristretto = callPackage ./applications/ristretto { };

      xfmpc = callPackage ./applications/xfmpc { };

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

    }
    // lib.optionalAttrs config.allowAliases {
      #### ALIASES
      genericUpdater = throw "xfce.genericUpdater has been removed: use pkgs.genericUpdater directly"; # added 2025-12-22

      mkXfceDerivation = lib.warnOnInstantiate ''
        xfce.mkXfceDerivation has been deprecated, please use stdenv.mkDerivation
        directly. You can migrate by adding `pkg-config`, `xfce4-dev-tools`, and
        `wrapGAppsHook3` to your nativeBuildInputs and `--enable-maintainer-mode`
        to your configureFlags.
      '' (callPackage ./mkXfceDerivation.nix { }); # added 2025-12-22

      xfce4-datetime-plugin = throw ''
        xfce4-datetime-plugin has been removed: this plugin has been merged into the xfce4-panel's built-in clock
        plugin and thus no longer maintained upstream, see https://gitlab.xfce.org/xfce/xfce4-panel/-/issues/563.
      ''; # Added 2025-05-20
    }
  );
}
// lib.optionalAttrs config.allowAliases {
  # These aliases need to be placed outside the scope or they will shadow the attributes from parent scope.
  exo = lib.warnOnInstantiate "‘xfce.exo’ was moved to top-level. Please use ‘pkgs.xfce4-exo’ directly" pkgs.xfce4-exo; # Added on 2025-12-23
  garcon = lib.warnOnInstantiate "‘xfce.garcon’ was moved to top-level. Please use ‘pkgs.garcon’ directly" pkgs.garcon; # Added on 2025-12-23
  libxfce4ui = lib.warnOnInstantiate "‘xfce.libxfce4ui’ was moved to top-level. Please use ‘pkgs.libxfce4ui’ directly" pkgs.libxfce4ui; # Added on 2025-12-23
  libxfce4util = lib.warnOnInstantiate "‘xfce.libxfce4util’ was moved to top-level. Please use ‘pkgs.libxfce4util’ directly" pkgs.libxfce4util; # Added on 2025-12-23
  libxfce4windowing = lib.warnOnInstantiate "‘xfce.libxfce4windowing’ was moved to top-level. Please use ‘pkgs.libxfce4windowing’ directly" pkgs.libxfce4windowing; # Added on 2025-12-23
  xfce4-dev-tools = lib.warnOnInstantiate "‘xfce.xfce4-dev-tools’ was moved to top-level. Please use ‘pkgs.xfce4-dev-tools’ directly" pkgs.xfce4-dev-tools; # Added on 2025-12-23
  xfce4-panel = lib.warnOnInstantiate "‘xfce.xfce4-panel’ was moved to top-level. Please use ‘pkgs.xfce4-panel’ directly" pkgs.xfce4-panel; # Added on 2025-12-23
  xfconf = lib.warnOnInstantiate "‘xfce.xfconf’ was moved to top-level. Please use ‘pkgs.xfconf’ directly" pkgs.xfconf; # Added on 2025-12-23

  xfce4-alsa-plugin = lib.warnOnInstantiate "‘xfce.xfce4-alsa-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-alsa-plugin’ directly" pkgs.xfce4-alsa-plugin; # Added on 2025-12-19
  xfce4-battery-plugin = lib.warnOnInstantiate "‘xfce.xfce4-battery-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-battery-plugin’ directly" pkgs.xfce4-battery-plugin; # Added on 2025-12-19
  xfce4-clipman-plugin = lib.warnOnInstantiate "‘xfce.xfce4-clipman-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-clipman-plugin’ directly" pkgs.xfce4-clipman-plugin; # Added on 2025-12-19
  xfce4-cpufreq-plugin = lib.warnOnInstantiate "‘xfce.xfce4-cpufreq-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-cpufreq-plugin’ directly" pkgs.xfce4-cpufreq-plugin; # Added on 2025-12-19
  xfce4-cpugraph-plugin = lib.warnOnInstantiate "‘xfce.xfce4-cpugraph-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-cpugraph-plugin’ directly" pkgs.xfce4-cpugraph-plugin; # Added on 2025-12-19
  xfce4-dockbarx-plugin = lib.warnOnInstantiate "‘xfce.xfce4-dockbarx-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-dockbarx-plugin’ directly" pkgs.xfce4-dockbarx-plugin; # Added on 2025-12-19
  xfce4-docklike-plugin = lib.warnOnInstantiate "‘xfce.xfce4-docklike-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-docklike-plugin’ directly" pkgs.xfce4-docklike-plugin; # Added on 2025-12-19
  xfce4-eyes-plugin = lib.warnOnInstantiate "‘xfce.xfce4-eyes-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-eyes-plugin’ directly" pkgs.xfce4-eyes-plugin; # Added on 2025-12-19
  xfce4-fsguard-plugin = lib.warnOnInstantiate "‘xfce.xfce4-fsguard-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-fsguard-plugin’ directly" pkgs.xfce4-fsguard-plugin; # Added on 2025-12-19
  xfce4-genmon-plugin = lib.warnOnInstantiate "‘xfce.xfce4-genmon-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-genmon-plugin’ directly" pkgs.xfce4-genmon-plugin; # Added on 2025-12-19
  xfce4-i3-workspaces-plugin = lib.warnOnInstantiate "‘xfce.xfce4-i3-workspaces-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-i3-workspaces-plugin’ directly" pkgs.xfce4-i3-workspaces-plugin; # Added on 2025-12-19
  xfce4-mailwatch-plugin = lib.warnOnInstantiate "‘xfce.xfce4-mailwatch-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-mailwatch-plugin’ directly" pkgs.xfce4-mailwatch-plugin; # Added on 2025-12-19
  xfce4-mpc-plugin = lib.warnOnInstantiate "‘xfce.xfce4-mpc-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-mpc-plugin’ directly" pkgs.xfce4-mpc-plugin; # Added on 2025-12-19
  xfce4-netload-plugin = lib.warnOnInstantiate "‘xfce.xfce4-netload-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-netload-plugin’ directly" pkgs.xfce4-netload-plugin; # Added on 2025-12-19
  xfce4-notes-plugin = lib.warnOnInstantiate "‘xfce.xfce4-notes-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-notes-plugin’ directly" pkgs.xfce4-notes-plugin; # Added on 2025-12-19
  xfce4-systemload-plugin = lib.warnOnInstantiate "‘xfce.xfce4-systemload-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-systemload-plugin’ directly" pkgs.xfce4-systemload-plugin; # Added on 2025-12-19
  xfce4-time-out-plugin = lib.warnOnInstantiate "‘xfce.xfce4-time-out-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-time-out-plugin’ directly" pkgs.xfce4-time-out-plugin; # Added on 2025-12-19
  xfce4-timer-plugin = lib.warnOnInstantiate "‘xfce.xfce4-timer-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-timer-plugin’ directly" pkgs.xfce4-timer-plugin; # Added on 2025-12-19
  xfce4-verve-plugin = lib.warnOnInstantiate "‘xfce.xfce4-verve-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-verve-plugin’ directly" pkgs.xfce4-verve-plugin; # Added on 2025-12-19
  xfce4-xkb-plugin = lib.warnOnInstantiate "‘xfce.xfce4-xkb-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-xkb-plugin’ directly" pkgs.xfce4-xkb-plugin; # Added on 2025-12-19
  xfce4-weather-plugin = lib.warnOnInstantiate "‘xfce.xfce4-weather-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-weather-plugin’ directly" pkgs.xfce4-weather-plugin; # Added on 2025-12-19
  xfce4-whiskermenu-plugin = lib.warnOnInstantiate "‘xfce.xfce4-whiskermenu-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-whiskermenu-plugin’ directly" pkgs.xfce4-whiskermenu-plugin; # Added on 2025-12-19
  xfce4-windowck-plugin = lib.warnOnInstantiate "‘xfce.xfce4-windowck-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-windowck-plugin’ directly" pkgs.xfce4-windowck-plugin; # Added on 2025-12-19
  xfce4-pulseaudio-plugin = lib.warnOnInstantiate "‘xfce.xfce4-pulseaudio-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-pulseaudio-plugin’ directly" pkgs.xfce4-pulseaudio-plugin; # Added on 2025-12-19
  xfce4-sensors-plugin = lib.warnOnInstantiate "‘xfce.xfce4-sensors-plugin’ was moved to top-level. Please use ‘pkgs.xfce4-sensors-plugin’ directly" pkgs.xfce4-sensors-plugin; # Added on 2025-12-19

}
