{ config, pkgs, lib, gnome3 }:


lib.makeScope pkgs.newScope (self: with self; {

  switchboardPlugs = [
    switchboard-plug-a11y switchboard-plug-about
    switchboard-plug-applications switchboard-plug-bluetooth
    switchboard-plug-datetime switchboard-plug-display
    switchboard-plug-keyboard switchboard-plug-mouse-touchpad
    switchboard-plug-network switchboard-plug-notifications
    switchboard-plug-onlineaccounts switchboard-plug-pantheon-shell
    switchboard-plug-power switchboard-plug-printers
    switchboard-plug-security-privacy switchboard-plug-sharing
    switchboard-plug-sound
  ];

  wingpanelIndicators = [
    wingpanel-applications-menu wingpanel-indicator-bluetooth
    wingpanel-indicator-datetime wingpanel-indicator-keyboard
    wingpanel-indicator-network wingpanel-indicator-nightlight
    wingpanel-indicator-notifications wingpanel-indicator-power
    wingpanel-indicator-session wingpanel-indicator-sound
  ];

  nixpkgs-github-update = callPackage ./nixpkgs_github_update { };

  updateScript = callPackage ./update.nix { };

  maintainers = with pkgs.stdenv.lib.maintainers; [ worldofpeace ];

  mutter = pkgs.gnome3.mutter328;

  elementary-gsettings-schemas = callPackage ./desktop/elementary-gsettings-schemas { };

  notes-up = pkgs.notes-up.override { withPantheon = true; };

  #### APPS

  appcenter = callPackage ./apps/appcenter { };

  elementary-calculator = callPackage ./apps/elementary-calculator { };

  elementary-calendar = callPackage ./apps/elementary-calendar { };

  elementary-camera = callPackage ./apps/elementary-camera { };

  elementary-code = callPackage ./apps/elementary-code { };

  elementary-files = callPackage ./apps/elementary-files { };

  elementary-feedback = callPackage ./apps/elementary-feedback { };

  elementary-music = callPackage ./apps/elementary-music { };

  elementary-photos = callPackage ./apps/elementary-photos { };

  elementary-screenshot-tool = callPackage ./apps/elementary-screenshot-tool { };

  elementary-terminal = callPackage ./apps/elementary-terminal { };

  elementary-videos = callPackage ./apps/elementary-videos { };

  sideload = callPackage ./apps/sideload { };

  #### DESKTOP

  elementary-default-settings = callPackage ./desktop/elementary-default-settings { };

  elementary-greeter = callPackage ./desktop/elementary-greeter { };

  elementary-onboarding = callPackage ./desktop/elementary-onboarding { };

  elementary-print-shim = callPackage ./desktop/elementary-print-shim { };

  elementary-session-settings = callPackage ./desktop/elementary-session-settings {
    inherit (gnome3) gnome-session gnome-keyring;
  };

  elementary-shortcut-overlay = callPackage ./desktop/elementary-shortcut-overlay { };

  extra-elementary-contracts = callPackage ./desktop/extra-elementary-contracts {
    inherit (gnome3) file-roller gnome-bluetooth;
  };

  gala = callPackage ./desktop/gala {
    inherit (gnome3) gnome-desktop;
  };

  wingpanel = callPackage ./desktop/wingpanel { };

  wingpanel-with-indicators = callPackage ./desktop/wingpanel/wrapper.nix {
    indicators = null;
  };

  #### LIBRARIES

  granite = callPackage ./granite { };

  #### SERVICES

  cerbere = callPackage ./services/cerbere { };

  contractor = callPackage ./services/contractor { };

  elementary-capnet-assist = callPackage ./services/elementary-capnet-assist { };

  elementary-dpms-helper = callPackage ./services/elementary-dpms-helper { };

  # We're using ubuntu and elementary's patchset due to reasons
  # explained here -> https://github.com/elementary/greeter/issues/92#issuecomment-376215614
  # Take note of "I am holding off on "fixing" this bug for as long as possible."
  elementary-settings-daemon = callPackage ./services/elementary-settings-daemon { };

  pantheon-agent-geoclue2 = callPackage ./services/pantheon-agent-geoclue2 { };

  pantheon-agent-polkit = callPackage ./services/pantheon-agent-polkit { };

  #### WINGPANEL INDICATORS

  wingpanel-applications-menu = callPackage ./desktop/wingpanel-indicators/applications-menu { };

  wingpanel-indicator-bluetooth = callPackage ./desktop/wingpanel-indicators/bluetooth { };

  wingpanel-indicator-datetime = callPackage ./desktop/wingpanel-indicators/datetime { };

  wingpanel-indicator-keyboard = callPackage ./desktop/wingpanel-indicators/keyboard { };

  wingpanel-indicator-network = callPackage ./desktop/wingpanel-indicators/network { };

  wingpanel-indicator-nightlight = callPackage ./desktop/wingpanel-indicators/nightlight { };

  wingpanel-indicator-notifications = callPackage ./desktop/wingpanel-indicators/notifications { };

  wingpanel-indicator-power = callPackage ./desktop/wingpanel-indicators/power { };

  wingpanel-indicator-session = callPackage ./desktop/wingpanel-indicators/session { };

  wingpanel-indicator-sound = callPackage ./desktop/wingpanel-indicators/sound { };

  #### SWITCHBOARD

  switchboard = callPackage ./apps/switchboard { };

  switchboard-with-plugs = callPackage ./apps/switchboard/wrapper.nix {
    plugs = null;
  };

  switchboard-plug-a11y = callPackage ./apps/switchboard-plugs/a11y { };

  switchboard-plug-about = callPackage ./apps/switchboard-plugs/about { };

  switchboard-plug-applications = callPackage ./apps/switchboard-plugs/applications { };

  switchboard-plug-bluetooth = callPackage ./apps/switchboard-plugs/bluetooth { };

  switchboard-plug-datetime = callPackage ./apps/switchboard-plugs/datetime { };

  switchboard-plug-display = callPackage ./apps/switchboard-plugs/display { };

  switchboard-plug-keyboard = callPackage ./apps/switchboard-plugs/keyboard { };

  switchboard-plug-mouse-touchpad = callPackage ./apps/switchboard-plugs/mouse-touchpad { };

  switchboard-plug-network = callPackage ./apps/switchboard-plugs/network { };

  switchboard-plug-notifications = callPackage ./apps/switchboard-plugs/notifications { };

  switchboard-plug-onlineaccounts = callPackage ./apps/switchboard-plugs/onlineaccounts { };

  switchboard-plug-pantheon-shell = callPackage ./apps/switchboard-plugs/pantheon-shell {
    inherit (gnome3) gnome-desktop;
  };

  switchboard-plug-power = callPackage ./apps/switchboard-plugs/power { };

  switchboard-plug-printers = callPackage ./apps/switchboard-plugs/printers { };

  switchboard-plug-security-privacy = callPackage ./apps/switchboard-plugs/security-privacy { };

  switchboard-plug-sharing = callPackage ./apps/switchboard-plugs/sharing { };

  switchboard-plug-sound = callPackage ./apps/switchboard-plugs/sound { };

  ### ARTWORK

  elementary-gtk-theme = callPackage ./artwork/elementary-gtk-theme { };

  elementary-icon-theme = callPackage ./artwork/elementary-icon-theme { };

  elementary-redacted-script = callPackage ./artwork/elementary-redacted-script { };

  elementary-sound-theme = callPackage ./artwork/elementary-sound-theme { };

  elementary-wallpapers = callPackage ./artwork/elementary-wallpapers { };

} // lib.optionalAttrs (config.allowAliases or true) {

  ### ALIASES

  inherit (pkgs) vala; # added 2019-10-10

})
