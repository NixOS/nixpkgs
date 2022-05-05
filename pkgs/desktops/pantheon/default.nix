{ config, pkgs, lib, gnome }:


lib.makeScope pkgs.newScope (self: with self; {

  switchboardPlugs = [
    switchboard-plug-a11y
    switchboard-plug-about
    switchboard-plug-applications
    switchboard-plug-bluetooth
    switchboard-plug-datetime
    switchboard-plug-display
    switchboard-plug-keyboard
    switchboard-plug-mouse-touchpad
    switchboard-plug-network
    switchboard-plug-notifications
    switchboard-plug-onlineaccounts
    switchboard-plug-pantheon-shell
    switchboard-plug-power
    switchboard-plug-printers
    switchboard-plug-security-privacy
    switchboard-plug-sharing
    switchboard-plug-sound
    switchboard-plug-wacom
  ];

  wingpanelIndicators = [
    wingpanel-applications-menu
    wingpanel-indicator-a11y
    wingpanel-indicator-bluetooth
    wingpanel-indicator-datetime
    wingpanel-indicator-keyboard
    wingpanel-indicator-network
    wingpanel-indicator-nightlight
    wingpanel-indicator-notifications
    wingpanel-indicator-power
    wingpanel-indicator-session
    wingpanel-indicator-sound
  ];

  maintainers = lib.teams.pantheon.members;

  mutter = pkgs.gnome.mutter338;

  # Using 3.38 to match Mutter used in Pantheon
  gnome-settings-daemon = pkgs.gnome.gnome-settings-daemon338;

  elementary-gsettings-schemas = callPackage ./desktop/elementary-gsettings-schemas { };

  touchegg = pkgs.touchegg.override { withPantheon = true; };

  #### APPS

  appcenter = callPackage ./apps/appcenter { };

  elementary-calculator = callPackage ./apps/elementary-calculator { };

  elementary-calendar = callPackage ./apps/elementary-calendar { };

  elementary-camera = callPackage ./apps/elementary-camera { };

  elementary-code = callPackage ./apps/elementary-code { };

  elementary-dock = callPackage ./apps/elementary-dock { };

  elementary-files = callPackage ./apps/elementary-files { };

  elementary-feedback = callPackage ./apps/elementary-feedback { };

  elementary-mail = callPackage ./apps/elementary-mail { };

  elementary-music = callPackage ./apps/elementary-music { };

  elementary-photos = callPackage ./apps/elementary-photos { };

  elementary-screenshot = callPackage ./apps/elementary-screenshot { };

  elementary-tasks = callPackage ./apps/elementary-tasks { };

  elementary-terminal = callPackage ./apps/elementary-terminal { };

  elementary-videos = callPackage ./apps/elementary-videos { };

  epiphany = pkgs.epiphany.override { withPantheon = true; };

  sideload = callPackage ./apps/sideload { };

  #### DESKTOP

  elementary-default-settings = callPackage ./desktop/elementary-default-settings { };

  elementary-greeter = callPackage ./desktop/elementary-greeter { };

  elementary-onboarding = callPackage ./desktop/elementary-onboarding { };

  elementary-print-shim = callPackage ./desktop/elementary-print-shim { };

  elementary-session-settings = callPackage ./desktop/elementary-session-settings {
    inherit (gnome) gnome-session gnome-keyring;
  };

  elementary-shortcut-overlay = callPackage ./desktop/elementary-shortcut-overlay { };

  file-roller-contract = callPackage ./desktop/file-roller-contract {
    inherit (gnome) file-roller;
  };

  gala = callPackage ./desktop/gala { };

  gnome-bluetooth-contract = callPackage ./desktop/gnome-bluetooth-contract {
    inherit (gnome) gnome-bluetooth_1_0;
  };

  wingpanel = callPackage ./desktop/wingpanel { };

  wingpanel-with-indicators = callPackage ./desktop/wingpanel/wrapper.nix {
    indicators = null;
  };

  #### LIBRARIES

  granite = callPackage ./granite { };

  granite7 = callPackage ./granite/7 { };

  #### SERVICES

  contractor = callPackage ./services/contractor { };

  elementary-capnet-assist = callPackage ./services/elementary-capnet-assist { };

  elementary-notifications = callPackage ./services/elementary-notifications { };

  elementary-settings-daemon = callPackage ./services/elementary-settings-daemon { };

  pantheon-agent-geoclue2 = callPackage ./services/pantheon-agent-geoclue2 { };

  pantheon-agent-polkit = callPackage ./services/pantheon-agent-polkit { };

  xdg-desktop-portal-pantheon = callPackage ./services/xdg-desktop-portal-pantheon { };

  #### WINGPANEL INDICATORS

  wingpanel-applications-menu = callPackage ./desktop/wingpanel-indicators/applications-menu { };

  wingpanel-indicator-a11y = callPackage ./desktop/wingpanel-indicators/a11y { };

  wingpanel-indicator-bluetooth = callPackage ./desktop/wingpanel-indicators/bluetooth { };

  wingpanel-indicator-datetime = callPackage ./desktop/wingpanel-indicators/datetime { };

  wingpanel-indicator-keyboard = callPackage ./desktop/wingpanel-indicators/keyboard { };

  wingpanel-indicator-network = callPackage ./desktop/wingpanel-indicators/network { };

  wingpanel-indicator-nightlight = callPackage ./desktop/wingpanel-indicators/nightlight { };

  wingpanel-indicator-notifications = callPackage ./desktop/wingpanel-indicators/notifications { };

  wingpanel-indicator-power = callPackage ./desktop/wingpanel-indicators/power {
    inherit (gnome) gnome-power-manager;
  };

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

  switchboard-plug-pantheon-shell = callPackage ./apps/switchboard-plugs/pantheon-shell { };

  switchboard-plug-power = callPackage ./apps/switchboard-plugs/power { };

  switchboard-plug-printers = callPackage ./apps/switchboard-plugs/printers { };

  switchboard-plug-security-privacy = callPackage ./apps/switchboard-plugs/security-privacy { };

  switchboard-plug-sharing = callPackage ./apps/switchboard-plugs/sharing { };

  switchboard-plug-sound = callPackage ./apps/switchboard-plugs/sound { };

  switchboard-plug-wacom = callPackage ./apps/switchboard-plugs/wacom { };

  ### ARTWORK

  elementary-gtk-theme = callPackage ./artwork/elementary-gtk-theme { };

  elementary-icon-theme = callPackage ./artwork/elementary-icon-theme { };

  elementary-redacted-script = callPackage ./artwork/elementary-redacted-script { };

  elementary-sound-theme = callPackage ./artwork/elementary-sound-theme { };

  elementary-wallpapers = callPackage ./artwork/elementary-wallpapers { };

  ### THIRD-PARTY

  # Put packages that ONLY works with Pantheon in pkgs/desktops/pantheon/third-party,
  # specifically third party switchboard plugins and wingpanel indicators.
  # Please call these packages in pkgs/top-level/all-packages.nix instead of this file.
  # https://github.com/NixOS/nixpkgs/issues/115222#issuecomment-906868654

}) // lib.optionalAttrs config.allowAliases {

  ### ALIASES

  # They need to be outside the scope or they will shadow the attributes from parent scope.

  vala = throw "The ‘pantheon.vala’ alias was removed on 2022-02-02, please use ‘pkgs.vala’ directly."; # added 2019-10-10

  cerbere = throw "Cerbere is now obsolete https://github.com/elementary/cerbere/releases/tag/2.5.1."; # added 2020-04-06

  elementary-screenshot-tool = throw "The ‘pantheon.elementary-screenshot-tool’ alias was removed on 2022-02-02, please use ‘pantheon.elementary-screenshot’ directly."; # added 2021-07-21

  evince = pkgs.gnome.evince; # added 2022-03-18

  extra-elementary-contracts = throw "extra-elementary-contracts has been removed as all contracts have been upstreamed."; # added 2021-12-01

  file-roller = pkgs.gnome.file-roller; # added 2022-03-12

  notes-up = throw "The ‘pantheon.notes-up’ alias was removed on 2022-02-02, please use ‘pkgs.notes-up’ directly."; # added 2021-12-18

}
