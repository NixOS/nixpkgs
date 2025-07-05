{
  config,
  pkgs,
  lib,
}:

# NOTE: New packages should generally go to top-level instead of here!
lib.makeScope pkgs.newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    updateScript = callPackage ./update.nix { };

    # Temporary helper until gdk-pixbuf supports multiple cache files.
    # This will go away, do not use outside Nixpkgs.
    _gdkPixbufCacheBuilder_DO_NOT_USE = callPackage ./gdk-pixbuf-cache-builder.nix { };

    # ISO installer
    # installerIso = callPackage ./installer.nix {};

    #### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

    gvfs = pkgs.gvfs.override { gnomeSupport = true; };

    nixos-gsettings-overrides = callPackage ./nixos/gsettings-overrides { };

  }
)
// lib.optionalAttrs config.allowAliases {
  #### Legacy aliases. They need to be outside the scope or they will shadow the attributes from parent scope.
  libgnome-keyring = throw "The ‘gnome.libgnome-keyring’ was moved to top-level. Please use ‘pkgs.libgnome-keyring’ directly."; # Added on 2024-06-22.
  libchamplain = throw "The ‘gnome.libchamplain’ was removed as unused. Please use ‘pkgs.libchamplain’ directly."; # Added on 2024-08-11.
  libsoup = throw "The ‘gnome.libsoup’ was removed as unused. Please use ‘pkgs.libsoup’."; # Added on 2024-08-11.

  gedit = throw "The ‘gnome.gedit’ alias was removed. Please use ‘pkgs.gedit’ directly."; # converted to throw on 2023-12-27
  gnome-todo = throw "The ‘gnome.gnome-todo’ alias was removed. Please use ‘pkgs.endeavour’ directly."; # converted to throw on 2023-12-27
  gnome-online-miners = throw "The ‘gnome.gnome-online-miners’ was removed, it was broken and abandoned."; # added on 2024-08-11.

  accerciser = throw "The ‘gnome.accerciser’ was moved to top-level. Please use ‘pkgs.accerciser’ directly."; # Added on 2024-06-22.
  adwaita-icon-theme = throw "The ‘gnome.adwaita-icon-theme’ was moved to top-level. Please use ‘pkgs.adwaita-icon-theme’ directly."; # Added on 2024-06-22.
  aisleriot = throw "The ‘gnome.aisleriot’ was moved to top-level. Please use ‘pkgs.aisleriot’ directly."; # Added on 2024-08-11.
  atomix = throw "The ‘gnome.atomix’ was moved to top-level. Please use ‘pkgs.atomix’ directly."; # Added on 2024-08-11.
  baobab = throw "The ‘gnome.baobab’ was moved to top-level. Please use ‘pkgs.baobab’ directly."; # Added on 2024-06-22.
  caribou = throw "The ‘gnome.caribou’ was moved to top-level. Please use ‘pkgs.caribou’ directly."; # Added on 2024-08-11.
  cheese = throw "The ‘gnome.cheese’ was moved to top-level. Please use ‘pkgs.cheese’ directly."; # Added on 2024-06-22.
  dconf-editor = throw "The ‘gnome.dconf-editor’ was moved to top-level. Please use ‘pkgs.dconf-editor’ directly."; # Added on 2024-06-22.
  devhelp = throw "The ‘gnome.devhelp’ was moved to top-level. Please use ‘pkgs.devhelp’ directly."; # Added on 2024-06-22.
  eog = throw "The ‘gnome.eog’ was moved to top-level. Please use ‘pkgs.eog’ directly."; # Added on 2024-06-22.
  epiphany = throw "The ‘gnome.epiphany’ was moved to top-level. Please use ‘pkgs.epiphany’ directly."; # Added on 2024-06-22.
  evince = throw "The ‘gnome.evince’ was moved to top-level. Please use ‘pkgs.evince’ directly."; # Added on 2024-06-13.
  evolution-data-server = throw "The ‘gnome.evolution-data-server’ was moved to top-level. Please use ‘pkgs.evolution-data-server’ directly."; # Added on 2024-06-13.
  file-roller = throw "The ‘gnome.file-roller’ was moved to top-level. Please use ‘pkgs.file-roller’ directly."; # Added on 2024-06-13.
  five-or-more = throw "The ‘gnome.five-or-more’ was moved to top-level. Please use ‘pkgs.five-or-more’ directly."; # Added on 2024-08-11.
  four-in-a-row = throw "The ‘gnome.four-in-a-row’ was moved to top-level. Please use ‘pkgs.four-in-a-row’ directly."; # Added on 2024-08-11.
  gdm = throw "The ‘gnome.gdm’ was moved to top-level. Please use ‘pkgs.gdm’ directly."; # Added on 2024-08-11.
  geary = throw "The ‘gnome.geary’ was moved to top-level. Please use ‘pkgs.geary’ directly."; # Added on 2024-06-22.
  ghex = throw "The ‘gnome.ghex’ was moved to top-level. Please use ‘pkgs.ghex’ directly."; # Added on 2024-06-22.
  gitg = throw "The ‘gnome.gitg’ was moved to top-level. Please use ‘pkgs.gitg’ directly."; # Added on 2024-06-22.
  gnome-applets = throw "The ‘gnome.gnome-applets’ was moved to top-level. Please use ‘pkgs.gnome-applets’ directly."; # Added on 2024-08-31.
  gnome-autoar = throw "The ‘gnome.gnome-autoar’ was moved to top-level. Please use ‘pkgs.gnome-autoar’ directly."; # Added on 2024-06-13.
  gnome-backgrounds = throw "The ‘gnome.gnome-backgrounds’ was moved to top-level. Please use ‘pkgs.gnome-backgrounds’ directly."; # Added on 2024-08-11.
  gnome-bluetooth = throw "The ‘gnome.gnome-bluetooth’ was moved to top-level. Please use ‘pkgs.gnome-bluetooth’ directly."; # Added on 2024-08-28.
  gnome-bluetooth_1_0 = throw "The ‘gnome.gnome-bluetooth_1_0’ was moved to top-level. Please use ‘pkgs.gnome-bluetooth_1_0’ directly."; # Added on 2024-08-28.
  gnome-boxes = throw "The ‘gnome.gnome-boxes’ was moved to top-level. Please use ‘pkgs.gnome-boxes’ directly."; # Added on 2024-08-11.
  gnome-characters = throw "The ‘gnome.gnome-characters’ was moved to top-level. Please use ‘pkgs.gnome-characters’ directly."; # Added on 2024-08-11.
  gnome-chess = throw "The ‘gnome.gnome-chess’ was moved to top-level. Please use ‘pkgs.gnome-chess’ directly."; # Added on 2024-08-11.
  gnome-clocks = throw "The ‘gnome.gnome-clocks’ was moved to top-level. Please use ‘pkgs.gnome-clocks’ directly."; # Added on 2024-08-11.
  gnome-color-manager = throw "The ‘gnome.gnome-color-manager’ was moved to top-level. Please use ‘pkgs.gnome-color-manager’ directly."; # Added on 2024-08-11.
  gnome-common = throw "The ‘gnome.gnome-common’ was moved to top-level. Please use ‘pkgs.gnome-common’ directly."; # Added on 2024-06-22.
  gnome-calculator = throw "The ‘gnome.gnome-calculator’ was moved to top-level. Please use ‘pkgs.gnome-calculator’ directly."; # Added on 2024-06-22.
  gnome-calendar = throw "The ‘gnome.gnome-calendar’ was moved to top-level. Please use ‘pkgs.gnome-calendar’ directly."; # Added on 2024-06-22.
  gnome-contacts = throw "The ‘gnome.gnome-contacts’ was moved to top-level. Please use ‘pkgs.gnome-contacts’ directly."; # Added on 2024-08-11.
  gnome-control-center = throw "The ‘gnome.gnome-control-center’ was moved to top-level. Please use ‘pkgs.gnome-control-center’ directly."; # Added on 2024-08-28.
  gnome-dictionary = throw "The ‘gnome.gnome-dictionary’ was moved to top-level. Please use ‘pkgs.gnome-dictionary’ directly."; # Added on 2024-06-22.
  gnome-disk-utility = throw "The ‘gnome.gnome-disk-utility’ was moved to top-level. Please use ‘pkgs.gnome-disk-utility’ directly."; # Added on 2024-06-22.
  gnome-flashback = throw "The ‘gnome.gnome-flashback’ was moved to top-level. Please use ‘pkgs.gnome-flashback’ directly."; # Added on 2024-08-31.
  gnome-font-viewer = throw "The ‘gnome.gnome-font-viewer’ was moved to top-level. Please use ‘pkgs.gnome-font-viewer’ directly."; # Added on 2024-06-22.
  gnome-initial-setup = throw "The ‘gnome.gnome-initial-setup’ was moved to top-level. Please use ‘pkgs.gnome-initial-setup’ directly."; # Added on 2024-08-11.
  gnome-keyring = throw "The ‘gnome.gnome-keyring’ was moved to top-level. Please use ‘pkgs.gnome-keyring’ directly."; # Added on 2024-06-22.
  gnome-klotski = throw "The ‘gnome.gnome-klotski’ was moved to top-level. Please use ‘pkgs.gnome-klotski’ directly."; # Added on 2024-08-11.
  gnome-logs = throw "The ‘gnome.gnome-logs’ was moved to top-level. Please use ‘pkgs.gnome-logs’ directly."; # Added on 2024-08-11.
  gnome-mahjongg = throw "The ‘gnome.gnome-mahjongg’ was moved to top-level. Please use ‘pkgs.gnome-mahjongg’ directly."; # Added on 2024-08-11.
  gnome-maps = throw "The ‘gnome.gnome-maps’ was moved to top-level. Please use ‘pkgs.gnome-maps’ directly."; # Added on 2024-08-11.
  gnome-mines = throw "The ‘gnome.gnome-mines’ was moved to top-level. Please use ‘pkgs.gnome-mines’ directly."; # Added on 2024-08-11.
  gnome-music = throw "The ‘gnome.gnome-music’ was moved to top-level. Please use ‘pkgs.gnome-music’ directly."; # Added on 2024-08-11.
  gnome-nettool = throw "The ‘gnome.gnome-nettool’ was moved to top-level. Please use ‘pkgs.gnome-nettool’ directly."; # Added on 2024-08-11.
  gnome-nibbles = throw "The ‘gnome.gnome-nibbles’ was moved to top-level. Please use ‘pkgs.gnome-nibbles’ directly."; # Added on 2024-08-11.
  gnome-notes = throw "The ‘gnome.gnome-notes’ was moved to top-level. Please use ‘pkgs.gnome-notes’ directly."; # Added on 2024-08-11.
  gnome-packagekit = throw "The ‘gnome.gnome-packagekit’ was moved to top-level. Please use ‘pkgs.gnome-packagekit’ directly."; # Added on 2024-06-22.
  gnome-panel = throw "The ‘gnome.gnome-panel’ was moved to top-level. Please use ‘pkgs.gnome-panel’ directly."; # Added on 2024-08-31.
  gnome-panel-with-modules = throw "The ‘gnome.gnome-panel-with-modules’ was moved to top-level. Please use ‘pkgs.gnome-panel-with-modules’ directly."; # Added on 2024-08-31.
  gnome-power-manager = throw "The ‘gnome.gnome-power-manager’ was moved to top-level. Please use ‘pkgs.gnome-power-manager’ directly."; # Added on 2024-08-11.
  gnome-remote-desktop = throw "The ‘gnome.gnome-remote-desktop’ was moved to top-level. Please use ‘pkgs.gnome-remote-desktop’ directly."; # Added on 2024-08-11.
  gnome-robots = throw "The ‘gnome.gnome-robots’ was moved to top-level. Please use ‘pkgs.gnome-robots’ directly."; # Added on 2024-08-11.
  gnome-screenshot = throw "The ‘gnome.gnome-screenshot’ was moved to top-level. Please use ‘pkgs.gnome-screenshot’ directly."; # Added on 2024-06-22.
  gnome-session = throw "The ‘gnome.gnome-session’ was moved to top-level. Please use ‘pkgs.gnome-session’ directly."; # Added on 2024-08-28.
  gnome-session-ctl = throw "The ‘gnome.gnome-session-ctl’ was moved to top-level. Please use ‘pkgs.gnome-session-ctl’ directly."; # Added on 2024-08-28.
  gnome-settings-daemon = throw "The ‘gnome.gnome-settings-daemon’ was moved to top-level. Please use ‘pkgs.gnome-settings-daemon’ directly."; # Added on 2024-08-28.
  gnome-settings-daemon43 = throw "The ‘gnome.gnome-settings-daemon43’ was removed since it is no longer used by Pantheon."; # Added on 2024-08-28.
  gnome-shell = throw "The ‘gnome.gnome-shell’ was moved to top-level. Please use ‘pkgs.gnome-shell’ directly."; # Added on 2024-08-28.
  gnome-shell-extensions = throw "The ‘gnome.gnome-shell-extensions’ was moved to top-level. Please use ‘pkgs.gnome-shell-extensions’ directly."; # Added on 2024-08-11.
  gnome-software = throw "The ‘gnome.gnome-software’ was moved to top-level. Please use ‘pkgs.gnome-software’ directly."; # Added on 2024-08-11.
  gnome-sound-recorder = throw "The ‘gnome.gnome-sound-recorder’ was moved to top-level. Please use ‘pkgs.gnome-sound-recorder’ directly."; # Added on 2024-08-11.
  gnome-sudoku = throw "The ‘gnome.gnome-sudoku’ was moved to top-level. Please use ‘pkgs.gnome-sudoku’ directly."; # Added on 2024-08-11.
  gnome-system-monitor = throw "The ‘gnome.gnome-system-monitor’ was moved to top-level. Please use ‘pkgs.gnome-system-monitor’ directly."; # Added on 2024-06-22.
  gnome-taquin = throw "The ‘gnome.gnome-taquin’ was moved to top-level. Please use ‘pkgs.gnome-taquin’ directly."; # Added on 2024-08-11.
  gnome-terminal = throw "The ‘gnome.gnome-terminal’ was moved to top-level. Please use ‘pkgs.gnome-terminal’ directly."; # Added on 2024-06-13.
  gnome-tetravex = throw "The ‘gnome.gnome-tetravex’ was moved to top-level. Please use ‘pkgs.gnome-tetravex’ directly."; # Added on 2024-08-11.
  gnome-themes-extra = throw "The ‘gnome.gnome-themes-extra’ was moved to top-level. Please use ‘pkgs.gnome-themes-extra’ directly."; # Added on 2024-06-22.
  gnome-tweaks = throw "The ‘gnome.gnome-tweaks’ was moved to top-level. Please use ‘pkgs.gnome-tweaks’ directly."; # Added on 2024-06-22.
  gnome-user-share = throw "The ‘gnome.gnome-user-share’ was moved to top-level. Please use ‘pkgs.gnome-user-share’ directly."; # Added on 2024-06-13.
  gnome-weather = throw "The ‘gnome.gnome-weather’ was moved to top-level. Please use ‘pkgs.gnome-weather’ directly."; # Added on 2024-08-11.
  gpaste = throw "The ‘gnome.gpaste’ was moved to top-level. Please use ‘pkgs.gpaste’ directly."; # Added on 2024-06-22.
  gtkhtml = throw "The ‘gnome.gtkhtml’ was moved to top-level. Please use ‘pkgs.gtkhtml’ directly."; # Added on 2024-08-11.
  gucharmap = throw "The ‘gnome.gucharmap’ was moved to top-level. Please use ‘pkgs.gucharmap’ directly."; # Added on 2024-06-22.
  hitori = throw "The ‘gnome.hitori’ was moved to top-level. Please use ‘pkgs.hitori’ directly."; # Added on 2024-08-11.
  iagno = throw "The ‘gnome.iagno’ was moved to top-level. Please use ‘pkgs.iagno’ directly."; # Added on 2024-08-11.
  lightsoff = throw "The ‘gnome.lightsoff’ was moved to top-level. Please use ‘pkgs.lightsoff’ directly."; # Added on 2024-08-11.
  metacity = throw "The ‘gnome.metacity’ was moved to top-level. Please use ‘pkgs.metacity’ directly."; # Added on 2024-08-11.
  mutter = throw "The ‘gnome.mutter’ was moved to top-level. Please use ‘pkgs.mutter’ directly."; # Added on 2024-08-28.
  mutter43 = throw "The ‘gnome.mutter43’ was removed since it is no longer used by Pantheon."; # Added on 2024-08-28.
  nautilus = throw "The ‘gnome.nautilus’ was moved to top-level. Please use ‘pkgs.nautilus’ directly."; # Added on 2024-06-13.
  networkmanager-openvpn = throw "The ‘gnome.networkmanager-openvpn’ was moved to top-level. Please use ‘pkgs.networkmanager-openvpn’ directly."; # Added on 2024-08-31.
  networkmanager-vpnc = throw "The ‘gnome.networkmanager-vpnc’ was moved to top-level. Please use ‘pkgs.networkmanager-vpnc’ directly."; # Added on 2024-08-31.
  networkmanager-openconnect = throw "The ‘gnome.networkmanager-openconnect’ was moved to top-level. Please use ‘pkgs.networkmanager-openconnect’ directly."; # Added on 2024-08-31.
  networkmanager-fortisslvpn = throw "The ‘gnome.networkmanager-fortisslvpn’ was moved to top-level. Please use ‘pkgs.networkmanager-fortisslvpn’ directly."; # Added on 2024-08-31.
  networkmanager-l2tp = throw "The ‘gnome.networkmanager-l2tp’ was moved to top-level. Please use ‘pkgs.networkmanager-l2tp’ directly."; # Added on 2024-08-31.
  networkmanager-iodine = throw "The ‘gnome.networkmanager-iodine’ was moved to top-level. Please use ‘pkgs.networkmanager-iodine’ directly."; # Added on 2024-08-31.
  nautilus-python = throw "The ‘gnome.nautilus-python’ was moved to top-level. Please use ‘pkgs.nautilus-python’ directly."; # Added on 2024-06-13.
  polari = throw "The ‘gnome.polari’ was moved to top-level. Please use ‘pkgs.polari’ directly."; # Added on 2024-08-11.
  pomodoro = throw "The ‘gnome.pomodoro’ was moved to top-level. Please use ‘pkgs.gnome-pomodoro’ directly."; # Added on 2024-06-22.
  quadrapassel = throw "The ‘gnome.quadrapassel’ was moved to top-level. Please use ‘pkgs.quadrapassel’ directly."; # Added on 2024-08-11.
  rygel = throw "The ‘gnome.rygel’ was moved to top-level. Please use ‘pkgs.rygel’ directly."; # Added on 2024-06-22.
  seahorse = throw "The ‘gnome.seahorse’ was moved to top-level. Please use ‘pkgs.seahorse’ directly."; # Added on 2024-06-22.
  simple-scan = throw "The ‘gnome.simple-scan’ was moved to top-level. Please use ‘pkgs.simple-scan’ directly."; # Added on 2024-06-22.
  sushi = throw "The ‘gnome.sushi’ was moved to top-level. Please use ‘pkgs.sushi’ directly."; # Added on 2024-06-22.
  swell-foop = throw "The ‘gnome.swell-foop’ was moved to top-level. Please use ‘pkgs.swell-foop’ directly."; # Added on 2024-08-11.
  tali = throw "The ‘gnome.tali’ was moved to top-level. Please use ‘pkgs.tali’ directly."; # Added on 2024-08-11.
  totem = throw "The ‘gnome.totem’ was moved to top-level. Please use ‘pkgs.totem’ directly."; # Added on 2024-06-22.
  vinagre = throw "The ‘gnome.vinagre’ was moved to top-level. Please use ‘pkgs.vinagre’ directly."; # Added on 2024-08-11.
  yelp = throw "The ‘gnome.yelp’ was moved to top-level. Please use ‘pkgs.yelp’ directly."; # Added on 2024-06-22.
  yelp-xsl = throw "The ‘gnome.yelp-xsl’ was moved to top-level. Please use ‘pkgs.yelp-xsl’ directly."; # Added on 2024-06-22.
  zenity = throw "The ‘gnome.zenity’ was moved to top-level. Please use ‘pkgs.zenity’ directly."; # Added on 2024-06-22.

  #### Removals
  anjuta = throw "`anjuta` was removed after not being maintained upstream and losing control of its official domain."; # 2024-01-16
}
