{
  pkgs,
  lib,
  config,
}:

lib.makeScope pkgs.newScope (
  self:
  { }
  // lib.optionalAttrs config.allowAliases {
    basePackages = throw "‘mate.basePackages’ was removed. Please list the packages you need explicitly"; # Added on 2026-02-14
    cajaExtensions = throw "‘mate.cajaExtensions’ was removed. Please list the extensions you need explicitly"; # Added on 2026-02-14
    extraPackages = throw "‘mate.extraPackages’ was removed. Please list the packages you need explicitly"; # Added on 2026-02-14
    mateUpdateScript = throw "‘mate.mateUpdateScript’ was removed. Please use ‘pkgs.gitUpdater’ directly"; # Added on 2026-02-14
    panelApplets = throw "‘mate.panelApplets’ was removed. Please list the applets you need explicitly"; # Added on 2026-02-14

    atril = lib.warnOnInstantiate "‘mate.atril’ was moved to top-level. Please use ‘pkgs.atril’ directly" pkgs.atril; # Added on 2026-02-08
    engrampa = lib.warnOnInstantiate "‘mate.engrampa’ was moved to top-level. Please use ‘pkgs.engrampa’ directly" pkgs.engrampa; # Added on 2026-02-08
    eom = lib.warnOnInstantiate "‘mate.eom’ was moved to top-level. Please use ‘pkgs.eom’ directly" pkgs.eom; # Added on 2026-02-08
    libmatekbd = lib.warnOnInstantiate "‘mate.libmatekbd’ was moved to top-level. Please use ‘pkgs.libmatekbd’ directly" pkgs.libmatekbd; # Added on 2026-02-08
    libmatemixer = lib.warnOnInstantiate "‘mate.libmatemixer’ was moved to top-level. Please use ‘pkgs.libmatemixer’ directly" pkgs.libmatemixer; # Added on 2026-02-08
    libmateweather = lib.warnOnInstantiate "‘mate.libmateweather’ was moved to top-level. Please use ‘pkgs.libmateweather’ directly" pkgs.libmateweather; # Added on 2026-02-08
    marco = lib.warnOnInstantiate "‘mate.marco’ was moved to top-level. Please use ‘pkgs.marco’ directly" pkgs.marco; # Added on 2026-02-08
    mate-applets = lib.warnOnInstantiate "‘mate.mate-applets’ was moved to top-level. Please use ‘pkgs.mate-applets’ directly" pkgs.mate-applets; # Added on 2026-02-08
    mate-backgrounds = lib.warnOnInstantiate "‘mate.mate-backgrounds’ was moved to top-level. Please use ‘pkgs.mate-backgrounds’ directly" pkgs.mate-backgrounds; # Added on 2026-02-08
    mate-calc = lib.warnOnInstantiate "‘mate.mate-calc’ was moved to top-level. Please use ‘pkgs.mate-calc’ directly" pkgs.mate-calc; # Added on 2026-02-08
    mate-common = lib.warnOnInstantiate "‘mate.mate-common’ was moved to top-level. Please use ‘pkgs.mate-common’ directly" pkgs.mate-common; # Added on 2026-02-08
    mate-control-center = lib.warnOnInstantiate "‘mate.mate-control-center’ was moved to top-level. Please use ‘pkgs.mate-control-center’ directly" pkgs.mate-control-center; # Added on 2026-02-08
    mate-desktop = lib.warnOnInstantiate "‘mate.mate-desktop’ was moved to top-level. Please use ‘pkgs.mate-desktop’ directly" pkgs.mate-desktop; # Added on 2026-02-08
    mate-gsettings-overrides = lib.warnOnInstantiate "‘mate.mate-gsettings-overrides’ was moved to top-level. Please use ‘pkgs.mate-gsettings-overrides’ directly" pkgs.mate-gsettings-overrides; # Added on 2026-02-08
    mate-icon-theme = lib.warnOnInstantiate "‘mate.mate-icon-theme’ was moved to top-level. Please use ‘pkgs.mate-icon-theme’ directly" pkgs.mate-icon-theme; # Added on 2026-02-08
    mate-icon-theme-faenza = lib.warnOnInstantiate "‘mate.mate-icon-theme-faenza’ was moved to top-level. Please use ‘pkgs.mate-icon-theme-faenza’ directly" pkgs.mate-icon-theme-faenza; # Added on 2026-02-08
    mate-indicator-applet = lib.warnOnInstantiate "‘mate.mate-indicator-applet’ was moved to top-level. Please use ‘pkgs.mate-indicator-applet’ directly" pkgs.mate-indicator-applet; # Added on 2026-02-08
    mate-media = lib.warnOnInstantiate "‘mate.mate-media’ was moved to top-level. Please use ‘pkgs.mate-media’ directly" pkgs.mate-media; # Added on 2026-02-08
    mate-menus = lib.warnOnInstantiate "‘mate.mate-menus’ was moved to top-level. Please use ‘pkgs.mate-menus’ directly" pkgs.mate-menus; # Added on 2026-02-08
    mate-netbook = lib.warnOnInstantiate "‘mate.mate-netbook’ was moved to top-level. Please use ‘pkgs.mate-netbook’ directly" pkgs.mate-netbook; # Added on 2026-02-08
    mate-notification-daemon = lib.warnOnInstantiate "‘mate.mate-notification-daemon’ was moved to top-level. Please use ‘pkgs.mate-notification-daemon’ directly" pkgs.mate-notification-daemon; # Added on 2026-02-08
    mate-polkit = lib.warnOnInstantiate "‘mate.mate-polkit’ was moved to top-level. Please use ‘pkgs.mate-polkit’ directly" pkgs.mate-polkit; # Added on 2026-02-08
    mate-power-manager = lib.warnOnInstantiate "‘mate.mate-power-manager’ was moved to top-level. Please use ‘pkgs.mate-power-manager’ directly" pkgs.mate-power-manager; # Added on 2026-02-08
    mate-screensaver = lib.warnOnInstantiate "‘mate.mate-screensaver’ was moved to top-level. Please use ‘pkgs.mate-screensaver’ directly" pkgs.mate-screensaver; # Added on 2026-02-08
    mate-sensors-applet = lib.warnOnInstantiate "‘mate.mate-sensors-applet’ was moved to top-level. Please use ‘pkgs.mate-sensors-applet’ directly" pkgs.mate-sensors-applet; # Added on 2026-02-08
    mate-session-manager = lib.warnOnInstantiate "‘mate.mate-session-manager’ was moved to top-level. Please use ‘pkgs.mate-session-manager’ directly" pkgs.mate-session-manager; # Added on 2026-02-08
    mate-system-monitor = lib.warnOnInstantiate "‘mate.mate-system-monitor’ was moved to top-level. Please use ‘pkgs.mate-system-monitor’ directly" pkgs.mate-system-monitor; # Added on 2026-02-08
    mate-terminal = lib.warnOnInstantiate "‘mate.mate-terminal’ was moved to top-level. Please use ‘pkgs.mate-terminal’ directly" pkgs.mate-terminal; # Added on 2026-02-08
    mate-themes = lib.warnOnInstantiate "‘mate.mate-themes’ was moved to top-level. Please use ‘pkgs.mate-themes’ directly" pkgs.mate-themes; # Added on 2026-02-08
    mate-tweak = lib.warnOnInstantiate "‘mate.mate-tweak’ was moved to top-level. Please use ‘pkgs.mate-tweak’ directly" pkgs.mate-tweak; # Added on 2026-02-08
    mate-user-guide = lib.warnOnInstantiate "‘mate.mate-user-guide’ was moved to top-level. Please use ‘pkgs.mate-user-guide’ directly" pkgs.mate-user-guide; # Added on 2026-02-08
    mate-user-share = lib.warnOnInstantiate "‘mate.mate-user-share’ was moved to top-level. Please use ‘pkgs.mate-user-share’ directly" pkgs.mate-user-share; # Added on 2026-02-08
    mate-utils = lib.warnOnInstantiate "‘mate.mate-utils’ was moved to top-level. Please use ‘pkgs.mate-utils’ directly" pkgs.mate-utils; # Added on 2026-02-08
    mate-wayland-session = lib.warnOnInstantiate "‘mate.mate-wayland-session’ was moved to top-level. Please use ‘pkgs.mate-wayland-session’ directly" pkgs.mate-wayland-session; # Added on 2026-02-08
    mozo = lib.warnOnInstantiate "‘mate.mozo’ was moved to top-level. Please use ‘pkgs.mozo’ directly" pkgs.mozo; # Added on 2026-02-08
    pluma = lib.warnOnInstantiate "‘mate.pluma’ was moved to top-level. Please use ‘pkgs.pluma’ directly" pkgs.pluma; # Added on 2026-02-08
    python-caja = lib.warnOnInstantiate "‘mate.python-caja’ was moved to top-level. Please use ‘pkgs.python-caja’ directly" pkgs.python-caja; # Added on 2026-02-08
    caja-dropbox = lib.warnOnInstantiate "‘mate.caja-dropbox’ was moved to top-level. Please use ‘pkgs.caja-dropbox’ directly" pkgs.caja-dropbox; # Added on 2026-02-08
    caja-extensions = lib.warnOnInstantiate "‘mate.caja-extensions’ was moved to top-level. Please use ‘pkgs.caja-extensions’ directly" pkgs.caja-extensions; # Added on 2026-02-08
    caja = lib.warnOnInstantiate "‘mate.caja’ was moved to top-level. Please use ‘pkgs.caja’ directly" pkgs.caja; # Added on 2026-02-08
    caja-with-extensions = lib.warnOnInstantiate "‘mate.caja-with-extensions’ was moved to top-level. Please use ‘pkgs.caja-with-extensions’ directly" pkgs.caja-with-extensions; # Added on 2026-02-08
    mate-panel = lib.warnOnInstantiate "‘mate.mate-panel’ was moved to top-level. Please use ‘pkgs.mate-panel’ directly" pkgs.mate-panel; # Added on 2026-02-08
    mate-panel-with-applets = lib.warnOnInstantiate "‘mate.mate-panel-with-applets’ was moved to top-level. Please use ‘pkgs.mate-panel-with-applets’ directly" pkgs.mate-panel-with-applets; # Added on 2026-02-08
    mate-settings-daemon = lib.warnOnInstantiate "‘mate.mate-settings-daemon’ was moved to top-level. Please use ‘pkgs.mate-settings-daemon’ directly" pkgs.mate-settings-daemon; # Added on 2026-02-08
    mate-settings-daemon-wrapped = lib.warnOnInstantiate "‘mate.mate-settings-daemon-wrapped’ was moved to top-level. Please use ‘pkgs.mate-settings-daemon-wrapped’ directly" pkgs.mate-settings-daemon-wrapped; # Added on 2026-02-08
  }
)
