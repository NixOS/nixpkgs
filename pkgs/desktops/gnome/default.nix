{ config, pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  updateScript = callPackage ./update.nix { };

  # Temporary helper until gdk-pixbuf supports multiple cache files.
  # This will go away, do not use outside Nixpkgs.
  _gdkPixbufCacheBuilder_DO_NOT_USE = callPackage ./gdk-pixbuf-cache-builder.nix { };

  libsoup = pkgs.libsoup.override { gnomeSupport = true; };
  libchamplain = pkgs.libchamplain.override { libsoup = libsoup; };

# ISO installer
# installerIso = callPackage ./installer.nix {};

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  adwaita-icon-theme = callPackage ./core/adwaita-icon-theme { };

  baobab = callPackage ./core/baobab { };

  caribou = callPackage ./core/caribou { };

  dconf-editor = callPackage ./core/dconf-editor { };

  empathy = callPackage ./core/empathy { };

  epiphany = callPackage ./core/epiphany { };

  evince = callPackage ./core/evince { }; # ToDo: dbus would prevent compilation, enable tests

  evolution-data-server = callPackage ./core/evolution-data-server { };

  gdm = callPackage ./core/gdm { };

  gnome-backgrounds = callPackage ./core/gnome-backgrounds { };

  gnome-bluetooth = callPackage ./core/gnome-bluetooth { };

  gnome-bluetooth_1_0 = callPackage ./core/gnome-bluetooth/1.0 { };

  gnome-color-manager = callPackage ./core/gnome-color-manager { };

  gnome-contacts = callPackage ./core/gnome-contacts { };

  gnome-control-center = callPackage ./core/gnome-control-center { };

  gnome-calculator = callPackage ./core/gnome-calculator { };

  gnome-common = callPackage ./core/gnome-common { };

  gnome-dictionary = callPackage ./core/gnome-dictionary { };

  gnome-disk-utility = callPackage ./core/gnome-disk-utility { };

  gnome-font-viewer = callPackage ./core/gnome-font-viewer { };

  gnome-keyring = callPackage ./core/gnome-keyring { };

  libgnome-keyring = callPackage ./core/libgnome-keyring { };

  gnome-initial-setup = callPackage ./core/gnome-initial-setup { };

  gnome-online-miners = callPackage ./core/gnome-online-miners { };

  gnome-remote-desktop = callPackage ./core/gnome-remote-desktop { };

  gnome-session = callPackage ./core/gnome-session { };

  gnome-session-ctl = callPackage ./core/gnome-session/ctl.nix { };

  gnome-shell = callPackage ./core/gnome-shell { };

  gnome-shell-extensions = callPackage ./core/gnome-shell-extensions { };

  gnome-screenshot = callPackage ./core/gnome-screenshot { };

  gnome-settings-daemon = callPackage ./core/gnome-settings-daemon { };

  # Using 3.38 to match Mutter used in Pantheon
  gnome-settings-daemon338 = callPackage ./core/gnome-settings-daemon/3.38 { };

  gnome-software = callPackage ./core/gnome-software { };

  gnome-system-monitor = callPackage ./core/gnome-system-monitor { };

  gnome-terminal = callPackage ./core/gnome-terminal { };

  gnome-themes-extra = callPackage ./core/gnome-themes-extra { };

  gnome-user-share = callPackage ./core/gnome-user-share { };

  gucharmap = callPackage ./core/gucharmap { };

  gvfs = pkgs.gvfs.override { gnomeSupport = true; };

  eog = callPackage ./core/eog { };

  mutter = callPackage ./core/mutter { };

  # Needed for elementary's gala and greeter until support for higher versions is provided
  mutter338 = callPackage ./core/mutter/3.38 { };

  nautilus = callPackage ./core/nautilus { };

  networkmanager-openvpn = pkgs.networkmanager-openvpn.override {
    withGnome = true;
  };

  networkmanager-vpnc = pkgs.networkmanager-vpnc.override {
    withGnome = true;
  };

  networkmanager-openconnect = pkgs.networkmanager-openconnect.override {
    withGnome = true;
  };

  networkmanager-fortisslvpn = pkgs.networkmanager-fortisslvpn.override {
    withGnome = true;
  };

  networkmanager-l2tp = pkgs.networkmanager-l2tp.override {
    withGnome = true;
  };

  networkmanager-iodine = pkgs.networkmanager-iodine.override {
    withGnome = true;
  };

  nixos-gsettings-overrides = callPackage ./nixos/gsettings-overrides { };

  rygel = callPackage ./core/rygel { };

  simple-scan = callPackage ./core/simple-scan { };

  sushi = callPackage ./core/sushi { };

  totem = callPackage ./core/totem { };

  yelp = callPackage ./core/yelp { };

  yelp-xsl = callPackage ./core/yelp-xsl { };

  zenity = callPackage ./core/zenity { };


#### Apps (http://ftp.acc.umu.se/pub/GNOME/apps/)

  accerciser = callPackage ./apps/accerciser { };

  cheese = callPackage ./apps/cheese { };

  file-roller = callPackage ./apps/file-roller { };

  gedit = callPackage ./apps/gedit { };

  ghex = callPackage ./apps/ghex { };

  gnome-boxes = callPackage ./apps/gnome-boxes { };

  gnome-calendar = callPackage ./apps/gnome-calendar { };

  gnome-characters = callPackage ./apps/gnome-characters { };

  gnome-clocks = callPackage ./apps/gnome-clocks { };

  gnome-logs = callPackage ./apps/gnome-logs { };

  gnome-maps = callPackage ./apps/gnome-maps { };

  gnome-music = callPackage ./apps/gnome-music { };

  gnome-nettool = callPackage ./apps/gnome-nettool { };

  gnome-notes = callPackage ./apps/gnome-notes { };

  gnome-power-manager = callPackage ./apps/gnome-power-manager { };

  gnome-sound-recorder = callPackage ./apps/gnome-sound-recorder { };

  gnome-weather = callPackage ./apps/gnome-weather { };

  polari = callPackage ./apps/polari { };

  seahorse = callPackage ./apps/seahorse { };

  vinagre = callPackage ./apps/vinagre { };

#### Dev http://ftp.gnome.org/pub/GNOME/devtools/

  anjuta = callPackage ./devtools/anjuta { };

  devhelp = callPackage ./devtools/devhelp { };

#### Games

  aisleriot = callPackage ./games/aisleriot { };

  atomix = callPackage ./games/atomix { };

  five-or-more = callPackage ./games/five-or-more { };

  four-in-a-row = callPackage ./games/four-in-a-row { };

  gnome-chess = callPackage ./games/gnome-chess { };

  gnome-klotski = callPackage ./games/gnome-klotski { };

  gnome-mahjongg = callPackage ./games/gnome-mahjongg { };

  gnome-mines = callPackage ./games/gnome-mines { };

  gnome-nibbles = callPackage ./games/gnome-nibbles { };

  gnome-robots = callPackage ./games/gnome-robots { };

  gnome-sudoku = callPackage ./games/gnome-sudoku { };

  gnome-taquin = callPackage ./games/gnome-taquin { };

  gnome-tetravex = callPackage ./games/gnome-tetravex { };

  hitori = callPackage ./games/hitori { };

  iagno = callPackage ./games/iagno { };

  lightsoff = callPackage ./games/lightsoff { };

  swell-foop = callPackage ./games/swell-foop { };

  tali = callPackage ./games/tali { };

  quadrapassel = callPackage ./games/quadrapassel { };

#### Misc -- other packages on http://ftp.gnome.org/pub/GNOME/sources/

  geary = callPackage ./misc/geary { };

  gitg = callPackage ./misc/gitg { };

  gnome-applets = callPackage ./misc/gnome-applets { };

  gnome-flashback = callPackage ./misc/gnome-flashback { };

  gnome-panel = callPackage ./misc/gnome-panel {
    autoreconfHook = pkgs.autoreconfHook269;
  };

  gnome-tweaks = callPackage ./misc/gnome-tweaks { };

  gpaste = callPackage ./misc/gpaste { };

  metacity = callPackage ./misc/metacity { };

  nautilus-python = callPackage ./misc/nautilus-python { };

  gtkhtml = callPackage ./misc/gtkhtml { enchant = pkgs.enchant1; };

  pomodoro = callPackage ./misc/pomodoro { };

  gnome-autoar = callPackage ./misc/gnome-autoar { };

  gnome-packagekit = callPackage ./misc/gnome-packagekit { };
}) // lib.optionalAttrs config.allowAliases {
#### Legacy aliases. They need to be outside the scope or they will shadow the attributes from parent scope.

  gnome-desktop = throw "The ‘gnome.gnome-desktop’ alias was removed. Please use ‘pkgs.gnome-desktop’ directly."; # converted to throw on 2022-10-26
  gnome-todo = pkgs.endeavour; # added 2022-07-30
  libgnome-games-support = throw "The ‘gnome.libgnome-games-support’ alias was removed. Please use ‘pkgs.libgnome-games-support’ directly."; # converted to throw on 2022-10-26

  gnome-books = throw "The ‘gnome.gnome-books’ package was removed as it is broken and abandoned."; # added 2022-10-26
  gnome-documents = throw "The ‘gnome.gnome-documents’ package was removed as it is broken and abandoned."; # added 2022-10-26
  gnome-devel-docs = throw "The ‘gnome.gnome-devel-docs’ package was removed as it is outdated and no longer relevant."; # added 2022-10-26

}
