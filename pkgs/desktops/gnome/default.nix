{ config, pkgs, lib }:

# NOTE: New packages should generally go to top-level instead of here!
lib.makeScope pkgs.newScope (self:
let
  inherit (self) callPackage;
in
{
  updateScript = callPackage ./update.nix { };

  # Temporary helper until gdk-pixbuf supports multiple cache files.
  # This will go away, do not use outside Nixpkgs.
  _gdkPixbufCacheBuilder_DO_NOT_USE = callPackage ./gdk-pixbuf-cache-builder.nix { };

  libsoup = pkgs.libsoup.override { gnomeSupport = true; };
  libchamplain = pkgs.libchamplain.override { inherit (self) libsoup; };

# ISO installer
# installerIso = callPackage ./installer.nix {};

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  caribou = callPackage ./core/caribou { };

  gdm = callPackage ./core/gdm { };

  gnome-backgrounds = callPackage ./core/gnome-backgrounds { };

  gnome-bluetooth = callPackage ./core/gnome-bluetooth { };

  gnome-bluetooth_1_0 = callPackage ./core/gnome-bluetooth/1.0 { };

  gnome-color-manager = callPackage ./core/gnome-color-manager { };

  gnome-contacts = callPackage ./core/gnome-contacts { };

  gnome-control-center = callPackage ./core/gnome-control-center { };

  gnome-initial-setup = callPackage ./core/gnome-initial-setup { };

  gnome-online-miners = callPackage ./core/gnome-online-miners { };

  gnome-remote-desktop = callPackage ./core/gnome-remote-desktop { };

  gnome-session = callPackage ./core/gnome-session { };

  gnome-session-ctl = callPackage ./core/gnome-session/ctl.nix { };

  gnome-shell = callPackage ./core/gnome-shell { };

  gnome-shell-extensions = callPackage ./core/gnome-shell-extensions { };

  gnome-settings-daemon = callPackage ./core/gnome-settings-daemon { };

  # Using 43 to match Mutter used in Pantheon
  gnome-settings-daemon43 = callPackage ./core/gnome-settings-daemon/43 { };

  gnome-software = callPackage ./core/gnome-software { };

  gvfs = pkgs.gvfs.override { gnomeSupport = true; };

  mutter = callPackage ./core/mutter { };

  # Needed for elementary's gala, wingpanel and greeter until support for higher versions is provided
  mutter43 = callPackage ./core/mutter/43 { };

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

#### Apps (http://ftp.acc.umu.se/pub/GNOME/apps/)

  gnome-boxes = callPackage ./apps/gnome-boxes { };

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

  vinagre = callPackage ./apps/vinagre { };

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

  gnome-applets = callPackage ./misc/gnome-applets { };

  gnome-flashback = callPackage ./misc/gnome-flashback { };

  gnome-panel = callPackage ./misc/gnome-panel { };

  gnome-panel-with-modules = callPackage ./misc/gnome-panel/wrapper.nix { };

  metacity = callPackage ./misc/metacity { };

  gtkhtml = callPackage ./misc/gtkhtml { enchant = pkgs.enchant2; };
}) // lib.optionalAttrs config.allowAliases {
#### Legacy aliases. They need to be outside the scope or they will shadow the attributes from parent scope.
  libgnome-keyring = lib.warn "The ‘gnome.libgnome-keyring’ was moved to top-level. Please use ‘pkgs.libgnome-keyring’ directly." pkgs.libgnome-keyring; # Added on 2024-06-22.

  gedit = throw "The ‘gnome.gedit’ alias was removed. Please use ‘pkgs.gedit’ directly."; # converted to throw on 2023-12-27
  gnome-todo = throw "The ‘gnome.gnome-todo’ alias was removed. Please use ‘pkgs.endeavour’ directly."; # converted to throw on 2023-12-27

  accerciser = lib.warn "The ‘gnome.accerciser’ was moved to top-level. Please use ‘pkgs.accerciser’ directly." pkgs.accerciser; # Added on 2024-06-22.
  adwaita-icon-theme = lib.warn "The ‘gnome.adwaita-icon-theme’ was moved to top-level. Please use ‘pkgs.adwaita-icon-theme’ directly." pkgs.adwaita-icon-theme; # Added on 2024-06-22.
  baobab = lib.warn "The ‘gnome.baobab’ was moved to top-level. Please use ‘pkgs.baobab’ directly." pkgs.baobab; # Added on 2024-06-22.
  cheese = lib.warn "The ‘gnome.cheese’ was moved to top-level. Please use ‘pkgs.cheese’ directly." pkgs.cheese; # Added on 2024-06-22.
  dconf-editor = lib.warn "The ‘gnome.dconf-editor’ was moved to top-level. Please use ‘pkgs.dconf-editor’ directly." pkgs.dconf-editor; # Added on 2024-06-22.
  devhelp = lib.warn "The ‘gnome.devhelp’ was moved to top-level. Please use ‘pkgs.devhelp’ directly." pkgs.devhelp; # Added on 2024-06-22.
  eog = lib.warn "The ‘gnome.eog’ was moved to top-level. Please use ‘pkgs.eog’ directly." pkgs.eog; # Added on 2024-06-22.
  epiphany = lib.warn "The ‘gnome.epiphany’ was moved to top-level. Please use ‘pkgs.epiphany’ directly." pkgs.epiphany; # Added on 2024-06-22.
  evince = lib.warn "The ‘gnome.evince’ was moved to top-level. Please use ‘pkgs.evince’ directly." pkgs.evince; # Added on 2024-06-13.
  evolution-data-server = lib.warn "The ‘gnome.evolution-data-server’ was moved to top-level. Please use ‘pkgs.evolution-data-server’ directly." pkgs.evolution-data-server; # Added on 2024-06-13.
  file-roller = lib.warn "The ‘gnome.file-roller’ was moved to top-level. Please use ‘pkgs.file-roller’ directly." pkgs.file-roller; # Added on 2024-06-13.
  geary = lib.warn "The ‘gnome.geary’ was moved to top-level. Please use ‘pkgs.geary’ directly." pkgs.geary; # Added on 2024-06-22.
  ghex = lib.warn "The ‘gnome.ghex’ was moved to top-level. Please use ‘pkgs.ghex’ directly." pkgs.ghex; # Added on 2024-06-22.
  gitg = lib.warn "The ‘gnome.gitg’ was moved to top-level. Please use ‘pkgs.gitg’ directly." pkgs.gitg; # Added on 2024-06-22.
  gnome-autoar = lib.warn "The ‘gnome.gnome-autoar’ was moved to top-level. Please use ‘pkgs.gnome-autoar’ directly." pkgs.gnome-autoar; # Added on 2024-06-13.
  gnome-common = lib.warn "The ‘gnome.gnome-common’ was moved to top-level. Please use ‘pkgs.gnome-common’ directly." pkgs.gnome-common; # Added on 2024-06-22.
  gnome-calculator = lib.warn "The ‘gnome.gnome-calculator’ was moved to top-level. Please use ‘pkgs.gnome-calculator’ directly." pkgs.gnome-calculator; # Added on 2024-06-22.
  gnome-calendar = lib.warn "The ‘gnome.gnome-calendar’ was moved to top-level. Please use ‘pkgs.gnome-calendar’ directly." pkgs.gnome-calendar; # Added on 2024-06-22.
  gnome-dictionary = lib.warn "The ‘gnome.gnome-dictionary’ was moved to top-level. Please use ‘pkgs.gnome-dictionary’ directly." pkgs.gnome-dictionary; # Added on 2024-06-22.
  gnome-disk-utility = lib.warn "The ‘gnome.gnome-disk-utility’ was moved to top-level. Please use ‘pkgs.gnome-disk-utility’ directly." pkgs.gnome-disk-utility; # Added on 2024-06-22.
  gnome-font-viewer = lib.warn "The ‘gnome.gnome-font-viewer’ was moved to top-level. Please use ‘pkgs.gnome-font-viewer’ directly." pkgs.gnome-font-viewer; # Added on 2024-06-22.
  gnome-keyring = lib.warn "The ‘gnome.gnome-keyring’ was moved to top-level. Please use ‘pkgs.gnome-keyring’ directly." pkgs.gnome-keyring; # Added on 2024-06-22.
  gnome-packagekit = lib.warn "The ‘gnome.gnome-packagekit’ was moved to top-level. Please use ‘pkgs.gnome-packagekit’ directly." pkgs.gnome-packagekit; # Added on 2024-06-22.
  gnome-screenshot = lib.warn "The ‘gnome.gnome-screenshot’ was moved to top-level. Please use ‘pkgs.gnome-screenshot’ directly." pkgs.gnome-screenshot; # Added on 2024-06-22.
  gnome-system-monitor = lib.warn "The ‘gnome.gnome-system-monitor’ was moved to top-level. Please use ‘pkgs.gnome-system-monitor’ directly." pkgs.gnome-system-monitor; # Added on 2024-06-22.
  gnome-terminal = lib.warn "The ‘gnome.gnome-terminal’ was moved to top-level. Please use ‘pkgs.gnome-terminal’ directly." pkgs.gnome-terminal; # Added on 2024-06-13.
  gnome-themes-extra = lib.warn "The ‘gnome.gnome-themes-extra’ was moved to top-level. Please use ‘pkgs.gnome-themes-extra’ directly." pkgs.gnome-themes-extra; # Added on 2024-06-22.
  gnome-tweaks = lib.warn "The ‘gnome.gnome-tweaks’ was moved to top-level. Please use ‘pkgs.gnome-tweaks’ directly." pkgs.gnome-tweaks; # Added on 2024-06-22.
  gnome-user-share = lib.warn "The ‘gnome.gnome-user-share’ was moved to top-level. Please use ‘pkgs.gnome-user-share’ directly." pkgs.gnome-user-share; # Added on 2024-06-13.
  gpaste = lib.warn "The ‘gnome.gpaste’ was moved to top-level. Please use ‘pkgs.gpaste’ directly." pkgs.gpaste; # Added on 2024-06-22.
  gucharmap = lib.warn "The ‘gnome.gucharmap’ was moved to top-level. Please use ‘pkgs.gucharmap’ directly." pkgs.gucharmap; # Added on 2024-06-22.
  nautilus = lib.warn "The ‘gnome.nautilus’ was moved to top-level. Please use ‘pkgs.nautilus’ directly." pkgs.nautilus; # Added on 2024-06-13.
  nautilus-python = lib.warn "The ‘gnome.nautilus-python’ was moved to top-level. Please use ‘pkgs.nautilus-python’ directly." pkgs.nautilus-python; # Added on 2024-06-13.
  pomodoro = lib.warn "The ‘gnome.pomodoro’ was moved to top-level. Please use ‘pkgs.gnome-pomodoro’ directly." pkgs.gnome-pomodoro; # Added on 2024-06-22.
  rygel = lib.warn "The ‘gnome.rygel’ was moved to top-level. Please use ‘pkgs.rygel’ directly." pkgs.rygel; # Added on 2024-06-22.
  seahorse = lib.warn "The ‘gnome.seahorse’ was moved to top-level. Please use ‘pkgs.seahorse’ directly." pkgs.seahorse; # Added on 2024-06-22.
  simple-scan = lib.warn "The ‘gnome.simple-scan’ was moved to top-level. Please use ‘pkgs.simple-scan’ directly." pkgs.simple-scan; # Added on 2024-06-22.
  sushi = lib.warn "The ‘gnome.sushi’ was moved to top-level. Please use ‘pkgs.sushi’ directly." pkgs.sushi; # Added on 2024-06-22.
  totem = lib.warn "The ‘gnome.totem’ was moved to top-level. Please use ‘pkgs.totem’ directly." pkgs.totem; # Added on 2024-06-22.
  yelp = lib.warn "The ‘gnome.yelp’ was moved to top-level. Please use ‘pkgs.yelp’ directly." pkgs.yelp; # Added on 2024-06-22.
  yelp-xsl = lib.warn "The ‘gnome.yelp-xsl’ was moved to top-level. Please use ‘pkgs.yelp-xsl’ directly." pkgs.yelp-xsl; # Added on 2024-06-22.
  zenity = lib.warn "The ‘gnome.zenity’ was moved to top-level. Please use ‘pkgs.zenity’ directly." pkgs.zenity; # Added on 2024-06-22.

#### Removals
  anjuta = throw "`anjuta` was removed after not being maintained upstream and losing control of its official domain."; # 2024-01-16
}
