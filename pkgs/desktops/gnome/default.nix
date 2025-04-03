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
  libgnome-keyring = lib.warn "The ‘gnome.libgnome-keyring’ was moved to top-level. Please use ‘pkgs.libgnome-keyring’ directly." pkgs.libgnome-keyring; # Added on 2024-06-22.
  libchamplain = lib.warn "The ‘gnome.libchamplain’ was removed as unused. Please use ‘pkgs.libchamplain’ directly." pkgs.libchamplain; # Added on 2024-08-11.
  libsoup = lib.warn "The ‘gnome.libsoup’ was removed as unused. Please use ‘pkgs.libsoup’." pkgs.libsoup; # Added on 2024-08-11.

  gedit = throw "The ‘gnome.gedit’ alias was removed. Please use ‘pkgs.gedit’ directly."; # converted to throw on 2023-12-27
  gnome-todo = throw "The ‘gnome.gnome-todo’ alias was removed. Please use ‘pkgs.endeavour’ directly."; # converted to throw on 2023-12-27
  gnome-online-miners = throw "The ‘gnome.gnome-online-miners’ was removed, it was broken and abandoned."; # added on 2024-08-11.

  accerciser = lib.warn "The ‘gnome.accerciser’ was moved to top-level. Please use ‘pkgs.accerciser’ directly." pkgs.accerciser; # Added on 2024-06-22.
  adwaita-icon-theme = lib.warn "The ‘gnome.adwaita-icon-theme’ was moved to top-level. Please use ‘pkgs.adwaita-icon-theme’ directly." pkgs.adwaita-icon-theme; # Added on 2024-06-22.
  aisleriot = lib.warn "The ‘gnome.aisleriot’ was moved to top-level. Please use ‘pkgs.aisleriot’ directly." pkgs.aisleriot; # Added on 2024-08-11.
  atomix = lib.warn "The ‘gnome.atomix’ was moved to top-level. Please use ‘pkgs.atomix’ directly." pkgs.atomix; # Added on 2024-08-11.
  baobab = lib.warn "The ‘gnome.baobab’ was moved to top-level. Please use ‘pkgs.baobab’ directly." pkgs.baobab; # Added on 2024-06-22.
  caribou = lib.warn "The ‘gnome.caribou’ was moved to top-level. Please use ‘pkgs.caribou’ directly." pkgs.caribou; # Added on 2024-08-11.
  cheese = lib.warn "The ‘gnome.cheese’ was moved to top-level. Please use ‘pkgs.cheese’ directly." pkgs.cheese; # Added on 2024-06-22.
  dconf-editor = lib.warn "The ‘gnome.dconf-editor’ was moved to top-level. Please use ‘pkgs.dconf-editor’ directly." pkgs.dconf-editor; # Added on 2024-06-22.
  devhelp = lib.warn "The ‘gnome.devhelp’ was moved to top-level. Please use ‘pkgs.devhelp’ directly." pkgs.devhelp; # Added on 2024-06-22.
  eog = lib.warn "The ‘gnome.eog’ was moved to top-level. Please use ‘pkgs.eog’ directly." pkgs.eog; # Added on 2024-06-22.
  epiphany = lib.warn "The ‘gnome.epiphany’ was moved to top-level. Please use ‘pkgs.epiphany’ directly." pkgs.epiphany; # Added on 2024-06-22.
  evince = lib.warn "The ‘gnome.evince’ was moved to top-level. Please use ‘pkgs.evince’ directly." pkgs.evince; # Added on 2024-06-13.
  evolution-data-server = lib.warn "The ‘gnome.evolution-data-server’ was moved to top-level. Please use ‘pkgs.evolution-data-server’ directly." pkgs.evolution-data-server; # Added on 2024-06-13.
  file-roller = lib.warn "The ‘gnome.file-roller’ was moved to top-level. Please use ‘pkgs.file-roller’ directly." pkgs.file-roller; # Added on 2024-06-13.
  five-or-more = lib.warn "The ‘gnome.five-or-more’ was moved to top-level. Please use ‘pkgs.five-or-more’ directly." pkgs.five-or-more; # Added on 2024-08-11.
  four-in-a-row = lib.warn "The ‘gnome.four-in-a-row’ was moved to top-level. Please use ‘pkgs.four-in-a-row’ directly." pkgs.four-in-a-row; # Added on 2024-08-11.
  gdm = lib.warn "The ‘gnome.gdm’ was moved to top-level. Please use ‘pkgs.gdm’ directly." pkgs.gdm; # Added on 2024-08-11.
  geary = lib.warn "The ‘gnome.geary’ was moved to top-level. Please use ‘pkgs.geary’ directly." pkgs.geary; # Added on 2024-06-22.
  ghex = lib.warn "The ‘gnome.ghex’ was moved to top-level. Please use ‘pkgs.ghex’ directly." pkgs.ghex; # Added on 2024-06-22.
  gitg = lib.warn "The ‘gnome.gitg’ was moved to top-level. Please use ‘pkgs.gitg’ directly." pkgs.gitg; # Added on 2024-06-22.
  gnome-applets = lib.warn "The ‘gnome.gnome-applets’ was moved to top-level. Please use ‘pkgs.gnome-applets’ directly." pkgs.gnome-applets; # Added on 2024-08-31.
  gnome-autoar = lib.warn "The ‘gnome.gnome-autoar’ was moved to top-level. Please use ‘pkgs.gnome-autoar’ directly." pkgs.gnome-autoar; # Added on 2024-06-13.
  gnome-backgrounds = lib.warn "The ‘gnome.gnome-backgrounds’ was moved to top-level. Please use ‘pkgs.gnome-backgrounds’ directly." pkgs.gnome-backgrounds; # Added on 2024-08-11.
  gnome-bluetooth = lib.warn "The ‘gnome.gnome-bluetooth’ was moved to top-level. Please use ‘pkgs.gnome-bluetooth’ directly." pkgs.gnome-bluetooth; # Added on 2024-08-28.
  gnome-bluetooth_1_0 = lib.warn "The ‘gnome.gnome-bluetooth_1_0’ was moved to top-level. Please use ‘pkgs.gnome-bluetooth_1_0’ directly." pkgs.gnome-bluetooth_1_0; # Added on 2024-08-28.
  gnome-boxes = lib.warn "The ‘gnome.gnome-boxes’ was moved to top-level. Please use ‘pkgs.gnome-boxes’ directly." pkgs.gnome-boxes; # Added on 2024-08-11.
  gnome-characters = lib.warn "The ‘gnome.gnome-characters’ was moved to top-level. Please use ‘pkgs.gnome-characters’ directly." pkgs.gnome-characters; # Added on 2024-08-11.
  gnome-chess = lib.warn "The ‘gnome.gnome-chess’ was moved to top-level. Please use ‘pkgs.gnome-chess’ directly." pkgs.gnome-chess; # Added on 2024-08-11.
  gnome-clocks = lib.warn "The ‘gnome.gnome-clocks’ was moved to top-level. Please use ‘pkgs.gnome-clocks’ directly." pkgs.gnome-clocks; # Added on 2024-08-11.
  gnome-color-manager = lib.warn "The ‘gnome.gnome-color-manager’ was moved to top-level. Please use ‘pkgs.gnome-color-manager’ directly." pkgs.gnome-color-manager; # Added on 2024-08-11.
  gnome-common = lib.warn "The ‘gnome.gnome-common’ was moved to top-level. Please use ‘pkgs.gnome-common’ directly." pkgs.gnome-common; # Added on 2024-06-22.
  gnome-calculator = lib.warn "The ‘gnome.gnome-calculator’ was moved to top-level. Please use ‘pkgs.gnome-calculator’ directly." pkgs.gnome-calculator; # Added on 2024-06-22.
  gnome-calendar = lib.warn "The ‘gnome.gnome-calendar’ was moved to top-level. Please use ‘pkgs.gnome-calendar’ directly." pkgs.gnome-calendar; # Added on 2024-06-22.
  gnome-contacts = lib.warn "The ‘gnome.gnome-contacts’ was moved to top-level. Please use ‘pkgs.gnome-contacts’ directly." pkgs.gnome-contacts; # Added on 2024-08-11.
  gnome-control-center = lib.warn "The ‘gnome.gnome-control-center’ was moved to top-level. Please use ‘pkgs.gnome-control-center’ directly." pkgs.gnome-control-center; # Added on 2024-08-28.
  gnome-dictionary = lib.warn "The ‘gnome.gnome-dictionary’ was moved to top-level. Please use ‘pkgs.gnome-dictionary’ directly." pkgs.gnome-dictionary; # Added on 2024-06-22.
  gnome-disk-utility = lib.warn "The ‘gnome.gnome-disk-utility’ was moved to top-level. Please use ‘pkgs.gnome-disk-utility’ directly." pkgs.gnome-disk-utility; # Added on 2024-06-22.
  gnome-flashback = lib.warn "The ‘gnome.gnome-flashback’ was moved to top-level. Please use ‘pkgs.gnome-flashback’ directly." pkgs.gnome-flashback; # Added on 2024-08-31.
  gnome-font-viewer = lib.warn "The ‘gnome.gnome-font-viewer’ was moved to top-level. Please use ‘pkgs.gnome-font-viewer’ directly." pkgs.gnome-font-viewer; # Added on 2024-06-22.
  gnome-initial-setup = lib.warn "The ‘gnome.gnome-initial-setup’ was moved to top-level. Please use ‘pkgs.gnome-initial-setup’ directly." pkgs.gnome-initial-setup; # Added on 2024-08-11.
  gnome-keyring = lib.warn "The ‘gnome.gnome-keyring’ was moved to top-level. Please use ‘pkgs.gnome-keyring’ directly." pkgs.gnome-keyring; # Added on 2024-06-22.
  gnome-klotski = lib.warn "The ‘gnome.gnome-klotski’ was moved to top-level. Please use ‘pkgs.gnome-klotski’ directly." pkgs.gnome-klotski; # Added on 2024-08-11.
  gnome-logs = lib.warn "The ‘gnome.gnome-logs’ was moved to top-level. Please use ‘pkgs.gnome-logs’ directly." pkgs.gnome-logs; # Added on 2024-08-11.
  gnome-mahjongg = lib.warn "The ‘gnome.gnome-mahjongg’ was moved to top-level. Please use ‘pkgs.gnome-mahjongg’ directly." pkgs.gnome-mahjongg; # Added on 2024-08-11.
  gnome-maps = lib.warn "The ‘gnome.gnome-maps’ was moved to top-level. Please use ‘pkgs.gnome-maps’ directly." pkgs.gnome-maps; # Added on 2024-08-11.
  gnome-mines = lib.warn "The ‘gnome.gnome-mines’ was moved to top-level. Please use ‘pkgs.gnome-mines’ directly." pkgs.gnome-mines; # Added on 2024-08-11.
  gnome-music = lib.warn "The ‘gnome.gnome-music’ was moved to top-level. Please use ‘pkgs.gnome-music’ directly." pkgs.gnome-music; # Added on 2024-08-11.
  gnome-nettool = lib.warn "The ‘gnome.gnome-nettool’ was moved to top-level. Please use ‘pkgs.gnome-nettool’ directly." pkgs.gnome-nettool; # Added on 2024-08-11.
  gnome-nibbles = lib.warn "The ‘gnome.gnome-nibbles’ was moved to top-level. Please use ‘pkgs.gnome-nibbles’ directly." pkgs.gnome-nibbles; # Added on 2024-08-11.
  gnome-notes = lib.warn "The ‘gnome.gnome-notes’ was moved to top-level. Please use ‘pkgs.gnome-notes’ directly." pkgs.gnome-notes; # Added on 2024-08-11.
  gnome-packagekit = lib.warn "The ‘gnome.gnome-packagekit’ was moved to top-level. Please use ‘pkgs.gnome-packagekit’ directly." pkgs.gnome-packagekit; # Added on 2024-06-22.
  gnome-panel = lib.warn "The ‘gnome.gnome-panel’ was moved to top-level. Please use ‘pkgs.gnome-panel’ directly." pkgs.gnome-panel; # Added on 2024-08-31.
  gnome-panel-with-modules = lib.warn "The ‘gnome.gnome-panel-with-modules’ was moved to top-level. Please use ‘pkgs.gnome-panel-with-modules’ directly." pkgs.gnome-panel-with-modules; # Added on 2024-08-31.
  gnome-power-manager = lib.warn "The ‘gnome.gnome-power-manager’ was moved to top-level. Please use ‘pkgs.gnome-power-manager’ directly." pkgs.gnome-power-manager; # Added on 2024-08-11.
  gnome-remote-desktop = lib.warn "The ‘gnome.gnome-remote-desktop’ was moved to top-level. Please use ‘pkgs.gnome-remote-desktop’ directly." pkgs.gnome-remote-desktop; # Added on 2024-08-11.
  gnome-robots = lib.warn "The ‘gnome.gnome-robots’ was moved to top-level. Please use ‘pkgs.gnome-robots’ directly." pkgs.gnome-robots; # Added on 2024-08-11.
  gnome-screenshot = lib.warn "The ‘gnome.gnome-screenshot’ was moved to top-level. Please use ‘pkgs.gnome-screenshot’ directly." pkgs.gnome-screenshot; # Added on 2024-06-22.
  gnome-session = lib.warn "The ‘gnome.gnome-session’ was moved to top-level. Please use ‘pkgs.gnome-session’ directly." pkgs.gnome-session; # Added on 2024-08-28.
  gnome-session-ctl = lib.warn "The ‘gnome.gnome-session-ctl’ was moved to top-level. Please use ‘pkgs.gnome-session-ctl’ directly." pkgs.gnome-session-ctl; # Added on 2024-08-28.
  gnome-settings-daemon = lib.warn "The ‘gnome.gnome-settings-daemon’ was moved to top-level. Please use ‘pkgs.gnome-settings-daemon’ directly." pkgs.gnome-settings-daemon; # Added on 2024-08-28.
  gnome-settings-daemon43 = lib.warn "The ‘gnome.gnome-settings-daemon43’ was moved to top-level. Please use ‘pkgs.gnome-settings-daemon43’ directly." pkgs.gnome-settings-daemon43; # Added on 2024-08-28.
  gnome-shell = lib.warn "The ‘gnome.gnome-shell’ was moved to top-level. Please use ‘pkgs.gnome-shell’ directly." pkgs.gnome-shell; # Added on 2024-08-28.
  gnome-shell-extensions = lib.warn "The ‘gnome.gnome-shell-extensions’ was moved to top-level. Please use ‘pkgs.gnome-shell-extensions’ directly." pkgs.gnome-shell-extensions; # Added on 2024-08-11.
  gnome-software = lib.warn "The ‘gnome.gnome-software’ was moved to top-level. Please use ‘pkgs.gnome-software’ directly." pkgs.gnome-software; # Added on 2024-08-11.
  gnome-sound-recorder = lib.warn "The ‘gnome.gnome-sound-recorder’ was moved to top-level. Please use ‘pkgs.gnome-sound-recorder’ directly." pkgs.gnome-sound-recorder; # Added on 2024-08-11.
  gnome-sudoku = lib.warn "The ‘gnome.gnome-sudoku’ was moved to top-level. Please use ‘pkgs.gnome-sudoku’ directly." pkgs.gnome-sudoku; # Added on 2024-08-11.
  gnome-system-monitor = lib.warn "The ‘gnome.gnome-system-monitor’ was moved to top-level. Please use ‘pkgs.gnome-system-monitor’ directly." pkgs.gnome-system-monitor; # Added on 2024-06-22.
  gnome-taquin = lib.warn "The ‘gnome.gnome-taquin’ was moved to top-level. Please use ‘pkgs.gnome-taquin’ directly." pkgs.gnome-taquin; # Added on 2024-08-11.
  gnome-terminal = lib.warn "The ‘gnome.gnome-terminal’ was moved to top-level. Please use ‘pkgs.gnome-terminal’ directly." pkgs.gnome-terminal; # Added on 2024-06-13.
  gnome-tetravex = lib.warn "The ‘gnome.gnome-tetravex’ was moved to top-level. Please use ‘pkgs.gnome-tetravex’ directly." pkgs.gnome-tetravex; # Added on 2024-08-11.
  gnome-themes-extra = lib.warn "The ‘gnome.gnome-themes-extra’ was moved to top-level. Please use ‘pkgs.gnome-themes-extra’ directly." pkgs.gnome-themes-extra; # Added on 2024-06-22.
  gnome-tweaks = lib.warn "The ‘gnome.gnome-tweaks’ was moved to top-level. Please use ‘pkgs.gnome-tweaks’ directly." pkgs.gnome-tweaks; # Added on 2024-06-22.
  gnome-user-share = lib.warn "The ‘gnome.gnome-user-share’ was moved to top-level. Please use ‘pkgs.gnome-user-share’ directly." pkgs.gnome-user-share; # Added on 2024-06-13.
  gnome-weather = lib.warn "The ‘gnome.gnome-weather’ was moved to top-level. Please use ‘pkgs.gnome-weather’ directly." pkgs.gnome-weather; # Added on 2024-08-11.
  gpaste = lib.warn "The ‘gnome.gpaste’ was moved to top-level. Please use ‘pkgs.gpaste’ directly." pkgs.gpaste; # Added on 2024-06-22.
  gtkhtml = lib.warn "The ‘gnome.gtkhtml’ was moved to top-level. Please use ‘pkgs.gtkhtml’ directly." pkgs.gtkhtml; # Added on 2024-08-11.
  gucharmap = lib.warn "The ‘gnome.gucharmap’ was moved to top-level. Please use ‘pkgs.gucharmap’ directly." pkgs.gucharmap; # Added on 2024-06-22.
  hitori = lib.warn "The ‘gnome.hitori’ was moved to top-level. Please use ‘pkgs.hitori’ directly." pkgs.hitori; # Added on 2024-08-11.
  iagno = lib.warn "The ‘gnome.iagno’ was moved to top-level. Please use ‘pkgs.iagno’ directly." pkgs.iagno; # Added on 2024-08-11.
  lightsoff = lib.warn "The ‘gnome.lightsoff’ was moved to top-level. Please use ‘pkgs.lightsoff’ directly." pkgs.lightsoff; # Added on 2024-08-11.
  metacity = lib.warn "The ‘gnome.metacity’ was moved to top-level. Please use ‘pkgs.metacity’ directly." pkgs.metacity; # Added on 2024-08-11.
  mutter = lib.warn "The ‘gnome.mutter’ was moved to top-level. Please use ‘pkgs.mutter’ directly." pkgs.mutter; # Added on 2024-08-28.
  mutter43 = lib.warn "The ‘gnome.mutter43’ was moved to top-level. Please use ‘pkgs.mutter43’ directly." pkgs.mutter43; # Added on 2024-08-28.
  nautilus = lib.warn "The ‘gnome.nautilus’ was moved to top-level. Please use ‘pkgs.nautilus’ directly." pkgs.nautilus; # Added on 2024-06-13.
  networkmanager-openvpn = lib.warn "The ‘gnome.networkmanager-openvpn’ was moved to top-level. Please use ‘pkgs.networkmanager-openvpn’ directly." pkgs.networkmanager-openvpn; # Added on 2024-08-31.
  networkmanager-vpnc = lib.warn "The ‘gnome.networkmanager-vpnc’ was moved to top-level. Please use ‘pkgs.networkmanager-vpnc’ directly." pkgs.networkmanager-vpnc; # Added on 2024-08-31.
  networkmanager-openconnect = lib.warn "The ‘gnome.networkmanager-openconnect’ was moved to top-level. Please use ‘pkgs.networkmanager-openconnect’ directly." pkgs.networkmanager-openconnect; # Added on 2024-08-31.
  networkmanager-fortisslvpn = lib.warn "The ‘gnome.networkmanager-fortisslvpn’ was moved to top-level. Please use ‘pkgs.networkmanager-fortisslvpn’ directly." pkgs.networkmanager-fortisslvpn; # Added on 2024-08-31.
  networkmanager-l2tp = lib.warn "The ‘gnome.networkmanager-l2tp’ was moved to top-level. Please use ‘pkgs.networkmanager-l2tp’ directly." pkgs.networkmanager-l2tp; # Added on 2024-08-31.
  networkmanager-iodine = lib.warn "The ‘gnome.networkmanager-iodine’ was moved to top-level. Please use ‘pkgs.networkmanager-iodine’ directly." pkgs.networkmanager-iodine; # Added on 2024-08-31.
  nautilus-python = lib.warn "The ‘gnome.nautilus-python’ was moved to top-level. Please use ‘pkgs.nautilus-python’ directly." pkgs.nautilus-python; # Added on 2024-06-13.
  polari = lib.warn "The ‘gnome.polari’ was moved to top-level. Please use ‘pkgs.polari’ directly." pkgs.polari; # Added on 2024-08-11.
  pomodoro = lib.warn "The ‘gnome.pomodoro’ was moved to top-level. Please use ‘pkgs.gnome-pomodoro’ directly." pkgs.gnome-pomodoro; # Added on 2024-06-22.
  quadrapassel = lib.warn "The ‘gnome.quadrapassel’ was moved to top-level. Please use ‘pkgs.quadrapassel’ directly." pkgs.quadrapassel; # Added on 2024-08-11.
  rygel = lib.warn "The ‘gnome.rygel’ was moved to top-level. Please use ‘pkgs.rygel’ directly." pkgs.rygel; # Added on 2024-06-22.
  seahorse = lib.warn "The ‘gnome.seahorse’ was moved to top-level. Please use ‘pkgs.seahorse’ directly." pkgs.seahorse; # Added on 2024-06-22.
  simple-scan = lib.warn "The ‘gnome.simple-scan’ was moved to top-level. Please use ‘pkgs.simple-scan’ directly." pkgs.simple-scan; # Added on 2024-06-22.
  sushi = lib.warn "The ‘gnome.sushi’ was moved to top-level. Please use ‘pkgs.sushi’ directly." pkgs.sushi; # Added on 2024-06-22.
  swell-foop = lib.warn "The ‘gnome.swell-foop’ was moved to top-level. Please use ‘pkgs.swell-foop’ directly." pkgs.swell-foop; # Added on 2024-08-11.
  tali = lib.warn "The ‘gnome.tali’ was moved to top-level. Please use ‘pkgs.tali’ directly." pkgs.tali; # Added on 2024-08-11.
  totem = lib.warn "The ‘gnome.totem’ was moved to top-level. Please use ‘pkgs.totem’ directly." pkgs.totem; # Added on 2024-06-22.
  vinagre = lib.warn "The ‘gnome.vinagre’ was moved to top-level. Please use ‘pkgs.vinagre’ directly." pkgs.vinagre; # Added on 2024-08-11.
  yelp = lib.warn "The ‘gnome.yelp’ was moved to top-level. Please use ‘pkgs.yelp’ directly." pkgs.yelp; # Added on 2024-06-22.
  yelp-xsl = lib.warn "The ‘gnome.yelp-xsl’ was moved to top-level. Please use ‘pkgs.yelp-xsl’ directly." pkgs.yelp-xsl; # Added on 2024-06-22.
  zenity = lib.warn "The ‘gnome.zenity’ was moved to top-level. Please use ‘pkgs.zenity’ directly." pkgs.zenity; # Added on 2024-06-22.

  #### Removals
  anjuta = throw "`anjuta` was removed after not being maintained upstream and losing control of its official domain."; # 2024-01-16
}
