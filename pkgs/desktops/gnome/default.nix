{ config, pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  updateScript = callPackage ./update.nix { };

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

  gnome-books = callPackage ./apps/gnome-books { };

  gnome-boxes = callPackage ./apps/gnome-boxes { };

  gnome-calendar = callPackage ./apps/gnome-calendar { };

  gnome-characters = callPackage ./apps/gnome-characters { };

  gnome-clocks = callPackage ./apps/gnome-clocks { };

  gnome-documents = callPackage ./apps/gnome-documents { };

  gnome-logs = callPackage ./apps/gnome-logs { };

  gnome-maps = callPackage ./apps/gnome-maps { };

  gnome-music = callPackage ./apps/gnome-music { };

  gnome-nettool = callPackage ./apps/gnome-nettool { };

  gnome-notes = callPackage ./apps/gnome-notes { };

  gnome-power-manager = callPackage ./apps/gnome-power-manager { };

  gnome-sound-recorder = callPackage ./apps/gnome-sound-recorder { };

  gnome-todo = callPackage ./apps/gnome-todo {};

  gnome-weather = callPackage ./apps/gnome-weather { };

  polari = callPackage ./apps/polari { };

  seahorse = callPackage ./apps/seahorse { };

  vinagre = callPackage ./apps/vinagre { };

#### Dev http://ftp.gnome.org/pub/GNOME/devtools/

  anjuta = callPackage ./devtools/anjuta { };

  devhelp = callPackage ./devtools/devhelp { };

  gnome-devel-docs = callPackage ./devtools/gnome-devel-docs { };

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

  gnome-desktop = pkgs.gnome-desktop; # added 2022-03-16
  libgnome-games-support = pkgs.libgnome-games-support; # added 2022-02-19

  bijiben = throw "The ‘gnome.bijiben’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-notes’ directly."; # added 2018-09-26
  evolution_data_server = throw "The ‘gnome.evolution_data_server’ alias was removed on 2022-01-13. Please use ‘gnome.evolution-data-server’ directly."; # added 2018-02-25
  geocode_glib = throw "The ‘gnome.geocode_glib’ alias was removed on 2022-01-13. Please use ‘pkgs.geocode-glib’ directly."; # added 2018-02-25
  glib_networking = throw "The ‘gnome.glib_networking’ alias was removed on 2022-01-13. Please use ‘pkgs.glib-networking’ directly."; # added 2018-02-25
  gnome_common = throw "The ‘gnome.gnome_common’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-common’ directly."; # added 2018-02-25
  gnome_control_center = throw "The ‘gnome.gnome_control_center’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-control-center’ directly."; # added 2018-02-25
  gnome_desktop = throw "The ‘gnome.gnome_desktop’ alias was removed on 2022-01-13. Please use pkgs.gnome-desktop’ directly."; # added 2018-02-25
  gnome_keyring = throw "The ‘gnome.gnome_keyring’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-keyring’ directly."; # added 2018-02-25
  gnome_online_accounts = throw "The ‘gnome.gnome_online_accounts’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-online-accounts’ directly."; # added 2018-02-25
  gnome_session = throw "The ‘gnome.gnome_session’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-session’ directly."; # added 2018-02-25
  gnome_settings_daemon = throw "The ‘gnome.gnome_settings_daemon’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-settings-daemon’ directly."; # added 2018-02-25
  gnome_shell = throw "The ‘gnome.gnome_shell’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-shell’ directly."; # added 2018-02-25
  gnome_terminal = throw "The ‘gnome.gnome_terminal’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-terminal’ directly."; # added 2018-02-25
  gnome-themes-standard = throw "The ‘gnome.gnome-themes-standard’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-themes-extra’ directly."; # added 2018-03-14
  gnome_themes_standard = throw "The ‘gnome.gnome_themes_standard’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-themes-standard’ directly."; # added 2018-02-25
  gnome-tweak-tool = throw "The ‘gnome.gnome-tweak-tool’ alias was removed on 2022-01-13. Please use ‘gnome.gnome-tweaks’ directly."; # added 2018-03-21
  gsettings_desktop_schemas = throw "The ‘gnome.gsettings_desktop_schemas’ alias was removed on 2022-01-13. Please use ‘gnome.gsettings-desktop-schemas’ directly."; # added 2018-02-25
  libgames-support = throw "The ‘gnome.libgames-support’ alias was removed on 2022-01-13. Please use ‘pkgs.libgnome-games-support’ directly."; # added 2018-03-14
  libgnome_keyring = throw "The ‘gnome.libgnome_keyring’ alias was removed on 2022-01-13. Please use ‘gnome.libgnome-keyring’ directly."; # added 2018-02-25
  rarian = throw "The ‘gnome.rarian’ alias was removed on 2022-01-13. Please use ‘pkgs.rarian’ directly."; # added 2018-04-25
  networkmanager_fortisslvpn = throw "The ‘gnome.networkmanager_fortisslvpn’ alias was removed on 2022-01-13. Please use ‘gnome.networkmanager-fortisslvpn’ directly."; # added 2018-02-25
  networkmanager_iodine = throw "The ‘gnome.networkmanager_iodine’ alias was removed on 2022-01-13. Please use ‘gnome.networkmanager-iodine’ directly."; # added 2018-02-25
  networkmanager_l2tp = throw "The ‘gnome.networkmanager_l2tp’ alias was removed on 2022-01-13. Please use ‘gnome.networkmanager-l2tp’ directly."; # added 2018-02-25
  networkmanager_openconnect = throw "The ‘gnome.networkmanager_openconnect’ alias was removed on 2022-01-13. Please use ‘gnome.networkmanager-openconnect’ directly."; # added 2018-02-25
  networkmanager_openvpn = throw "The ‘gnome.networkmanager_openvpn’ alias was removed on 2022-01-13. Please use ‘gnome.networkmanager-openvpn’ directly."; # added 2018-02-25
  networkmanager_vpnc = throw "The ‘gnome.networkmanager_vpnc’ alias was removed on 2022-01-13. Please use ‘gnome.networkmanager-vpnc’ directly."; # added 2018-02-25
  yelp_xsl = throw "The ‘gnome.yelp_xsl’ alias was removed on 2022-01-13. Please use ‘gnome.yelp-xsl’ directly."; # added 2018-02-25
  yelp_tools = throw "The ‘gnome.yelp_tools’ alias was removed on 2022-01-13. Please use ‘gnome.yelp-tools’ directly."; # added 2018-02-25

  atk = throw "The ‘gnome.atk’ alias was removed on 2022-01-13. Please use ‘pkgs.atk’ directly."; # added 2019-02-08
  glib = throw "The ‘gnome.glib’ alias was removed on 2022-01-13. Please use ‘pkgs.glib’ directly."; # added 2019-02-08
  gobject-introspection = throw "The ‘gnome.gobject-introspection’ alias was removed on 2022-01-13. Please use ‘pkgs.gobject-introspection’ directly."; # added 2019-02-08
  gspell = throw "The ‘gnome.gspell’ alias was removed on 2022-01-13. Please use ‘pkgs.gspell’ directly."; # added 2019-02-08
  webkitgtk = throw "The ‘gnome.webkitgtk’ alias was removed on 2022-01-13. Please use ‘pkgs.webkitgtk’ directly."; # added 2019-02-08
  gtk3 = throw "The ‘gnome.gtk3’ alias was removed on 2022-01-13. Please use ‘pkgs.gtk3’ directly."; # added 2019-02-08
  gtkmm3 = throw "The ‘gnome.gtkmm3’ alias was removed on 2022-01-13. Please use ‘pkgs.gtkmm3’ directly."; # added 2019-02-08
  libgtop = throw "The ‘gnome.libgtop’ alias was removed on 2022-01-13. Please use ‘pkgs.libgtop’ directly."; # added 2019-02-08
  libgudev = throw "The ‘gnome.libgudev’ alias was removed on 2022-01-13. Please use ‘pkgs.libgudev’ directly."; # added 2019-02-08
  libhttpseverywhere = throw "The ‘gnome.libhttpseverywhere’ alias was removed on 2022-01-13. Please use ‘pkgs.libhttpseverywhere’ directly."; # added 2019-02-08
  librsvg = throw "The ‘gnome.librsvg’ alias was removed on 2022-01-13. Please use ‘pkgs.librsvg’ directly."; # added 2019-02-08
  libsecret = throw "The ‘gnome.libsecret’ alias was removed on 2022-01-13. Please use ‘pkgs.libsecret’ directly."; # added 2019-02-08
  gdk-pixbuf = throw "The ‘gnome.gdk-pixbuf’ alias was removed on 2022-01-13. Please use ‘pkgs.gdk-pixbuf’ directly."; # added 2019-02-08
  gtksourceview = throw "The ‘gnome.gtksourceview’ alias was removed on 2022-01-13. Please use ‘pkgs.gtksourceview’ directly."; # added 2019-02-08
  gtksourceviewmm = throw "The ‘gnome.gtksourceviewmm’ alias was removed on 2022-01-13. Please use ‘pkgs.gtksourceviewmm’ directly."; # added 2019-02-08
  gtksourceview4 = throw "The ‘gnome.gtksourceview4’ alias was removed on 2022-01-13. Please use ‘pkgs.gtksourceview4’ directly."; # added 2019-02-08
  easytag = throw "The ‘gnome.easytag’ alias was removed on 2022-01-13. Please use ‘pkgs.easytag’ directly."; # added 2019-02-08
  meld = throw "The ‘gnome.meld’ alias was removed on 2022-01-13. Please use ‘pkgs.meld’ directly."; # added 2019-02-08
  orca = throw "The ‘gnome.orca’ alias was removed on 2022-01-13. Please use ‘pkgs.orca’ directly."; # added 2019-02-08
  rhythmbox = throw "The ‘gnome.rhythmbox’ alias was removed on 2022-01-13. Please use ‘pkgs.rhythmbox’ directly."; # added 2019-02-08
  shotwell = throw "The ‘gnome.shotwell’ alias was removed on 2022-01-13. Please use ‘pkgs.shotwell’ directly."; # added 2019-02-08
  gnome-usage = throw "The ‘gnome.gnome-usage’ alias was removed on 2022-01-13. Please use ‘pkgs.gnome-usage’ directly."; # added 2019-02-08
  clutter = throw "The ‘gnome.clutter’ alias was removed on 2022-01-13. Please use ‘pkgs.clutter’ directly."; # added 2019-02-08
  clutter-gst = throw "The ‘gnome.clutter-gst’ alias was removed on 2022-01-13. Please use ‘pkgs.clutter-gst’ directly."; # added 2019-02-08
  clutter-gtk = throw "The ‘gnome.clutter-gtk’ alias was removed on 2022-01-13. Please use ‘pkgs.clutter-gtk’ directly."; # added 2019-02-08
  cogl = throw "The ‘gnome.cogl’ alias was removed on 2022-01-13. Please use ‘pkgs.cogl’ directly."; # added 2019-02-08
  gtk-vnc = throw "The ‘gnome.gtk-vnc’ alias was removed on 2022-01-13. Please use ‘pkgs.gtk-vnc’ directly."; # added 2019-02-08
  libdazzle = throw "The ‘gnome.libdazzle’ alias was removed on 2022-01-13. Please use ‘pkgs.libdazzle’ directly."; # added 2019-02-08
  libgda = throw "The ‘gnome.libgda’ alias was removed on 2022-01-13. Please use ‘pkgs.libgda’ directly."; # added 2019-02-08
  libgit2-glib = throw "The ‘gnome.libgit2-glib’ alias was removed on 2022-01-13. Please use ‘pkgs.libgit2-glib’ directly."; # added 2019-02-08
  libgxps = throw "The ‘gnome.libgxps’ alias was removed on 2022-01-13. Please use ‘pkgs.libgxps’ directly."; # added 2019-02-08
  libgdata = throw "The ‘gnome.libgdata’ alias was removed on 2022-01-13. Please use ‘pkgs.libgdata’ directly."; # added 2019-02-08
  libgepub = throw "The ‘gnome.libgepub’ alias was removed on 2022-01-13. Please use ‘pkgs.libgepub’ directly."; # added 2019-02-08
  libpeas = throw "The ‘gnome.libpeas’ alias was removed on 2022-01-13. Please use ‘pkgs.libpeas’ directly."; # added 2019-02-08
  libgee = throw "The ‘gnome.libgee’ alias was removed on 2022-01-13. Please use ‘pkgs.libgee’ directly."; # added 2019-02-08
  geocode-glib = throw "The ‘gnome.geocode-glib’ alias was removed on 2022-01-13. Please use ‘pkgs.geocode-glib’ directly."; # added 2019-02-08
  libgweather = throw "The ‘gnome.libgweather’ alias was removed on 2022-01-13. Please use ‘pkgs.libgweather’ directly."; # added 2019-02-08
  librest = throw "The ‘gnome.librest’ alias was removed on 2022-01-13. Please use ‘pkgs.librest’ directly."; # added 2019-02-08
  libzapojit = throw "The ‘gnome.libzapojit’ alias was removed on 2022-01-13. Please use ‘pkgs.libzapojit’ directly."; # added 2019-02-08
  libmediaart = throw "The ‘gnome.libmediaart’ alias was removed on 2022-01-13. Please use ‘pkgs.libmediaart’ directly."; # added 2019-02-08
  gfbgraph = throw "The ‘gnome.gfbgraph’ alias was removed on 2022-01-13. Please use ‘pkgs.gfbgraph’ directly."; # added 2019-02-08
  gexiv2 = throw "The ‘gnome.gexiv2’ alias was removed on 2022-01-13. Please use ‘pkgs.gexiv2’ directly."; # added 2019-02-08
  folks = throw "The ‘gnome.folks’ alias was removed on 2022-01-13. Please use ‘pkgs.folks’ directly."; # added 2019-02-08
  totem-pl-parser = throw "The ‘gnome.totem-pl-parser’ alias was removed on 2022-01-13. Please use ‘pkgs.totem-pl-parser’ directly."; # added 2019-02-08
  gcr = throw "The ‘gnome.gcr’ alias was removed on 2022-01-13. Please use ‘pkgs.gcr’ directly."; # added 2019-02-08
  gsound = throw "The ‘gnome.gsound’ alias was removed on 2022-01-13. Please use ‘pkgs.gsound’ directly."; # added 2019-02-08
  libgnomekbd = throw "The ‘gnome.libgnomekbd’ alias was removed on 2022-01-13. Please use ‘pkgs.libgnomekbd’ directly."; # added 2019-02-08
  vte = throw "The ‘gnome.vte’ alias was removed on 2022-01-13. Please use ‘pkgs.vte’ directly."; # added 2019-02-08
  vte_290 = throw "The ‘gnome.vte_290’ alias was removed on 2022-01-13. Please use ‘pkgs.vte_290’ directly."; # added 2019-02-08
  gnome-menus = throw "The ‘gnome.gnome-menus’ alias was removed on 2022-01-13. Please use ‘pkgs.gnome-menus’ directly."; # added 2019-02-08
  gdl = throw "The ‘gnome.gdl’ alias was removed on 2022-01-13. Please use ‘pkgs.gdl’ directly."; # added 2019-02-08


  gsettings-desktop-schemas = throw "The ‘gnome.gsettings-desktop-schemas’ alias was removed on 2022-01-13. Please use ‘pkgs.gsettings-desktop-schemas’ directly."; # added 2019-04-16
  gnome-video-effects = throw "The ‘gnome.gnome-video-effects’ alias was removed on 2022-01-13. Please use ‘pkgs.gnome-video-effects’ directly."; # added 2019-08-19
  gnome-online-accounts = throw "The ‘gnome.gnome-online-accounts’ alias was removed on 2022-01-13. Please use ‘pkgs.gnome-online-accounts’ directly."; # added 2019-08-23
  grilo = throw "The ‘gnome.grilo’ alias was removed on 2022-01-13. Please use ‘pkgs.grilo’ directly."; # added 2019-08-23
  grilo-plugins = throw "The ‘gnome.grilo-plugins’ alias was removed on 2022-01-13. Please use ‘pkgs.grilo-plugins’ directly."; # added 2019-08-23
  tracker = throw "The ‘gnome.tracker’ alias was removed on 2022-01-13. Please use ‘pkgs.tracker’ directly."; # added 2019-08-23
  tracker-miners = throw "The ‘gnome.tracker-miners’ alias was removed on 2022-01-13. Please use ‘pkgs.tracker-miners’ directly."; # added 2019-08-23
  gnome-photos = throw "The ‘gnome.gnome-photos’ alias was removed on 2022-01-13. Please use ‘pkgs.gnome-photos’ directly."; # added 2019-08-23
  glib-networking = throw "The ‘gnome.glib-networking’ alias was removed on 2022-01-13. Please use ‘pkgs.glib-networking’ directly."; # added 2019-09-02
  nemiver = throw "The ‘gnome.nemiver’ alias was removed on 2022-01-13. Please use ‘pkgs.nemiver’ directly."; # added 2019-09-09

  defaultIconTheme = throw "The ‘gnome.defaultIconTheme’ alias was removed on 2022-01-13. Please use ‘gnome.adwaita-icon-theme’ directly."; # added 2019-02-08
  gtk = throw "The ‘gnome.gtk’ alias was removed on 2022-01-13. Please use ‘pkgs.gtk3’ directly."; # added 2019-02-08
  gtkmm = throw "The ‘gnome.gtkmm’ alias was removed on 2022-01-13. Please use ‘pkgs.gtkmm3’ directly."; # added 2019-02-08
  rest = throw "The ‘gnome.rest’ alias was removed on 2022-01-13. Please use ‘pkgs.librest’ directly."; # added 2019-02-08

  pidgin-im-gnome-shell-extension = throw "The ‘gnome.pidgin-im-gnome-shell-extension’ alias was removed on 2022-01-13. Please use ‘pkgs.gnomeExtensions.pidgin-im-integration’ directly."; # added 2019-08-01

  vala = throw "The ‘gnome.vala’ alias was removed on 2022-01-13. Please use ‘pkgs.vala’ directly."; # added 2019-10-10

  gnome-user-docs = throw "The ‘gnome.gnome-user-docs’ alias was removed on 2022-01-13. Please use ‘pkgs.gnome-user-docs’ directly."; # added 2019-11-20

  gjs = throw "The ‘gnome.gjs’ alias was removed on 2022-01-13. Please use ‘pkgs.gjs’ directly."; # added 2019-01-05

  yelp-tools = throw "The ‘gnome.yelp-tools’ alias was removed on 2022-01-13. Please use ‘pkgs.yelp-tools’ directly."; # added 2019-11-20

  dconf = throw "The ‘gnome.dconf’ alias was removed on 2022-01-13. Please use ‘pkgs.dconf’ directly."; # added 2019-11-30

  networkmanagerapplet = throw "The ‘gnome.networkmanagerapplet’ alias was removed on 2022-01-13. Please use ‘pkgs.networkmanagerapplet’ directly."; # added 2019-12-12

  glade = throw "The ‘gnome.glade’ alias was removed on 2022-01-13. Please use ‘pkgs.glade’ directly."; # added 2020-05-15

  maintainers = throw "The ‘gnome.maintainers’ alias was removed on 2022-01-13. Please use ‘lib.teams.gnome.members’ directly."; # added 2020-04-01

  mutter328 = throw "Removed as Pantheon is upgraded to mutter338.";

  mutter334 = throw "Removed as Pantheon is upgraded to mutter338.";

  gnome-getting-started-docs = throw "Removed in favour of gnome-tour.";
}
