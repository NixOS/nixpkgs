{
  config,
  lib,
  linuxPackages,
  pkgs,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
}:

# New packages should go to top-level instead of here!
# TODO: Remove this scope entirely in NixOS 26.11.
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "xfce";
  f = (
    self:
    let
      inherit (self) callPackage;
    in
    {

    }
    // lib.optionalAttrs config.allowAliases {
      #### ALIASES
      genericUpdater = throw "‘xfce.genericUpdater’ has been removed: use ‘pkgs.genericUpdater’ directly"; # added 2025-12-22
      xinitrc = throw "‘xfce.xinitrc’ has been removed: use ‘pkgs.xfce4-session.xinitrc’ directly"; # added 2025-12-28
      thunar-bare = throw "‘xfce.thunar-bare’ has been removed: use ‘pkgs.thunar-unwrapped’ directly"; # added 2025-12-28

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

      exo = lib.warnOnInstantiate "‘xfce.exo’ was moved to top-level. Please use ‘pkgs.xfce4-exo’ directly" pkgs.xfce4-exo; # Added on 2025-12-23
      garcon = lib.warnOnInstantiate "‘xfce.garcon’ was moved to top-level. Please use ‘pkgs.garcon’ directly" pkgs.garcon; # Added on 2025-12-23
      libxfce4ui = lib.warnOnInstantiate "‘xfce.libxfce4ui’ was moved to top-level. Please use ‘pkgs.libxfce4ui’ directly" pkgs.libxfce4ui; # Added on 2025-12-23
      libxfce4util = lib.warnOnInstantiate "‘xfce.libxfce4util’ was moved to top-level. Please use ‘pkgs.libxfce4util’ directly" pkgs.libxfce4util; # Added on 2025-12-23
      libxfce4windowing = lib.warnOnInstantiate "‘xfce.libxfce4windowing’ was moved to top-level. Please use ‘pkgs.libxfce4windowing’ directly" pkgs.libxfce4windowing; # Added on 2025-12-23
      xfce4-dev-tools = lib.warnOnInstantiate "‘xfce.xfce4-dev-tools’ was moved to top-level. Please use ‘pkgs.xfce4-dev-tools’ directly" pkgs.xfce4-dev-tools; # Added on 2025-12-23
      xfce4-panel = lib.warnOnInstantiate "‘xfce.xfce4-panel’ was moved to top-level. Please use ‘pkgs.xfce4-panel’ directly" pkgs.xfce4-panel; # Added on 2025-12-23
      xfconf = lib.warnOnInstantiate "‘xfce.xfconf’ was moved to top-level. Please use ‘pkgs.xfconf’ directly" pkgs.xfconf; # Added on 2025-12-23
      thunar = lib.warnOnInstantiate "‘xfce.thunar’ was moved to top-level. Please use ‘pkgs.thunar’ directly" pkgs.thunar; # Added on 2025-12-26
      thunar-unwrapped = lib.warnOnInstantiate "‘xfce.thunar-unwrapped’ was moved to top-level. Please use ‘pkgs.thunar-unwrapped’ directly" pkgs.thunar-unwrapped; # Added on 2025-12-26
      thunar-volman = lib.warnOnInstantiate "‘xfce.thunar-volman’ was moved to top-level. Please use ‘pkgs.thunar-volman’ directly" pkgs.thunar-volman; # Added on 2025-12-26
      tumbler = lib.warnOnInstantiate "‘xfce.tumbler’ was moved to top-level. Please use ‘pkgs.tumbler’ directly" pkgs.tumbler; # Added on 2025-12-26
      xfce4-session = lib.warnOnInstantiate "‘xfce.xfce4-session’ was moved to top-level. Please use ‘pkgs.xfce4-session’ directly" pkgs.xfce4-session; # Added on 2025-12-26
      xfce4-settings = lib.warnOnInstantiate "‘xfce.xfce4-settings’ was moved to top-level. Please use ‘pkgs.xfce4-settings’ directly" pkgs.xfce4-settings; # Added on 2025-12-26
      xfce4-power-manager = lib.warnOnInstantiate "‘xfce.xfce4-power-manager’ was moved to top-level. Please use ‘pkgs.xfce4-power-manager’ directly" pkgs.xfce4-power-manager; # Added on 2025-12-26
      xfdesktop = lib.warnOnInstantiate "‘xfce.xfdesktop’ was moved to top-level. Please use ‘pkgs.xfdesktop’ directly" pkgs.xfdesktop; # Added on 2025-12-26
      xfwm4 = lib.warnOnInstantiate "‘xfce.xfwm4’ was moved to top-level. Please use ‘pkgs.xfwm4’ directly" pkgs.xfwm4; # Added on 2025-12-26
      xfce4-appfinder = lib.warnOnInstantiate "‘xfce.xfce4-appfinder’ was moved to top-level. Please use ‘pkgs.xfce4-appfinder’ directly" pkgs.xfce4-appfinder; # Added on 2025-12-26
      catfish = lib.warnOnInstantiate "‘xfce.catfish’ was moved to top-level. Please use ‘pkgs.catfish’ directly" pkgs.catfish; # Added on 2025-12-26
      gigolo = lib.warnOnInstantiate "‘xfce.gigolo’ was moved to top-level. Please use ‘pkgs.gigolo’ directly" pkgs.gigolo; # Added on 2025-12-26
      mousepad = lib.warnOnInstantiate "‘xfce.mousepad’ was moved to top-level. Please use ‘pkgs.mousepad’ directly" pkgs.mousepad; # Added on 2025-12-26
      orage = lib.warnOnInstantiate "‘xfce.orage’ was moved to top-level. Please use ‘pkgs.orage’ directly" pkgs.orage; # Added on 2025-12-26
      parole = lib.warnOnInstantiate "‘xfce.parole’ was moved to top-level. Please use ‘pkgs.parole’ directly" pkgs.parole; # Added on 2025-12-26
      ristretto = lib.warnOnInstantiate "‘xfce.ristretto’ was moved to top-level. Please use ‘pkgs.ristretto’ directly" pkgs.ristretto; # Added on 2025-12-26
      xfburn = lib.warnOnInstantiate "‘xfce.xfburn’ was moved to top-level. Please use ‘pkgs.xfburn’ directly" pkgs.xfburn; # Added on 2025-12-26
      xfce4-dict = lib.warnOnInstantiate "‘xfce.xfce4-dict’ was moved to top-level. Please use ‘pkgs.xfce4-dict’ directly" pkgs.xfce4-dict; # Added on 2025-12-26
      xfce4-notifyd = lib.warnOnInstantiate "‘xfce.xfce4-notifyd’ was moved to top-level. Please use ‘pkgs.xfce4-notifyd’ directly" pkgs.xfce4-notifyd; # Added on 2025-12-26
      xfce4-panel-profiles = lib.warnOnInstantiate "‘xfce.xfce4-panel-profiles’ was moved to top-level. Please use ‘pkgs.xfce4-panel-profiles’ directly" pkgs.xfce4-panel-profiles; # Added on 2025-12-26
      xfce4-screensaver = lib.warnOnInstantiate "‘xfce.xfce4-screensaver’ was moved to top-level. Please use ‘pkgs.xfce4-screensaver’ directly" pkgs.xfce4-screensaver; # Added on 2025-12-26
      xfce4-screenshooter = lib.warnOnInstantiate "‘xfce.xfce4-screenshooter’ was moved to top-level. Please use ‘pkgs.xfce4-screenshooter’ directly" pkgs.xfce4-screenshooter; # Added on 2025-12-26
      xfce4-taskmanager = lib.warnOnInstantiate "‘xfce.xfce4-taskmanager’ was moved to top-level. Please use ‘pkgs.xfce4-taskmanager’ directly" pkgs.xfce4-taskmanager; # Added on 2025-12-26
      xfce4-terminal = lib.warnOnInstantiate "‘xfce.xfce4-terminal’ was moved to top-level. Please use ‘pkgs.xfce4-terminal’ directly" pkgs.xfce4-terminal; # Added on 2025-12-26
      xfce4-volumed-pulse = lib.warnOnInstantiate "‘xfce.xfce4-volumed-pulse’ was moved to top-level. Please use ‘pkgs.xfce4-volumed-pulse’ directly" pkgs.xfce4-volumed-pulse; # Added on 2025-12-26
      xfdashboard = lib.warnOnInstantiate "‘xfce.xfdashboard’ was moved to top-level. Please use ‘pkgs.xfdashboard’ directly" pkgs.xfdashboard; # Added on 2025-12-26
      xfmpc = lib.warnOnInstantiate "‘xfce.xfmpc’ was moved to top-level. Please use ‘pkgs.xfmpc’ directly" pkgs.xfmpc; # Added on 2025-12-26
      xfce4-icon-theme = lib.warnOnInstantiate "‘xfce.xfce4-icon-theme’ was moved to top-level. Please use ‘pkgs.xfce4-icon-theme’ directly" pkgs.xfce4-icon-theme; # Added on 2025-12-26
      xfwm4-themes = lib.warnOnInstantiate "‘xfce.xfwm4-themes’ was moved to top-level. Please use ‘pkgs.xfwm4-themes’ directly" pkgs.xfwm4-themes; # Added on 2025-12-26

      thunar-archive-plugin = lib.warnOnInstantiate "‘xfce.thunar-archive-plugin’ was moved to top-level. Please use ‘pkgs.thunar-archive-plugin’ directly" pkgs.thunar-archive-plugin; # Added on 2025-12-26
      thunar-dropbox-plugin = lib.warnOnInstantiate "‘xfce.thunar-dropbox-plugin’ was moved to top-level. Please use ‘pkgs.thunar-dropbox-plugin’ directly" pkgs.thunar-dropbox-plugin; # Added on 2025-12-26
      thunar-media-tags-plugin = lib.warnOnInstantiate "‘xfce.thunar-media-tags-plugin’ was moved to top-level. Please use ‘pkgs.thunar-media-tags-plugin’ directly" pkgs.thunar-media-tags-plugin; # Added on 2025-12-26
      thunar-vcs-plugin = lib.warnOnInstantiate "‘xfce.thunar-vcs-plugin’ was moved to top-level. Please use ‘pkgs.thunar-vcs-plugin’ directly" pkgs.thunar-vcs-plugin; # Added on 2025-12-26

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
  );
}
