{ config, pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {
  updateScript = callPackage ./update.nix { };

  /* Remove packages of packagesToRemove from packages, based on their names

     Type:
       removePackagesByName :: [package] -> [package] -> [package]

     Example:
       removePackagesByName [ nautilus file-roller ] [ file-roller totem ]
       => [ nautilus ]
  */
  removePackagesByName = packages: packagesToRemove:
    let
      namesToRemove = map lib.getName packagesToRemove;
    in
      lib.filter (x: !(builtins.elem (lib.getName x) namesToRemove)) packages;

  maintainers = with pkgs.lib.maintainers; [ lethalman jtojnar hedning worldofpeace ];

  libsoup = pkgs.libsoup.override { gnomeSupport = true; };
  libchamplain = pkgs.libchamplain.override { libsoup = libsoup; };
  gnome3 = self // { recurseForDerivations = false; };

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

  gnome-color-manager = callPackage ./core/gnome-color-manager { };

  gnome-contacts = callPackage ./core/gnome-contacts { };

  gnome-control-center = callPackage ./core/gnome-control-center { };

  gnome-calculator = callPackage ./core/gnome-calculator { };

  gnome-common = callPackage ./core/gnome-common { };

  gnome-desktop = callPackage ./core/gnome-desktop { };

  gnome-dictionary = callPackage ./core/gnome-dictionary { };

  gnome-disk-utility = callPackage ./core/gnome-disk-utility { };

  gnome-font-viewer = callPackage ./core/gnome-font-viewer { };

  gnome-keyring = callPackage ./core/gnome-keyring { };

  libgnome-keyring = callPackage ./core/libgnome-keyring { };

  gnome-initial-setup = callPackage ./core/gnome-initial-setup { };

  gnome-online-miners = callPackage ./core/gnome-online-miners { };

  gnome-remote-desktop = callPackage ./core/gnome-remote-desktop { };

  gnome-session = callPackage ./core/gnome-session { };

  gnome-shell = callPackage ./core/gnome-shell { };

  gnome-shell-extensions = callPackage ./core/gnome-shell-extensions { };

  gnome-screenshot = callPackage ./core/gnome-screenshot { };

  gnome-settings-daemon = callPackage ./core/gnome-settings-daemon { };

  gnome-software = callPackage ./core/gnome-software { };

  gnome-system-monitor = callPackage ./core/gnome-system-monitor { };

  gnome-terminal = callPackage ./core/gnome-terminal { };

  gnome-themes-extra = callPackage ./core/gnome-themes-extra { };

  gnome-user-share = callPackage ./core/gnome-user-share { };

  gucharmap = callPackage ./core/gucharmap { };

  gvfs = pkgs.gvfs.override { gnomeSupport = true; };

  eog = callPackage ./core/eog { };

  mutter = callPackage ./core/mutter { };

  # Needed for elementary's gala and greeter until they get around to adapting to all the API breaking changes in libmutter-3
  # A more detailed explaination can be seen here https://decathorpe.com/2018/09/04/call-for-help-pantheon-on-fedora-29.html
  # See Also: https://github.com/elementary/gala/issues/303
  mutter328 = callPackage ./core/mutter/3.28.nix { };

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

  vino = callPackage ./core/vino { };

  yelp = callPackage ./core/yelp { };

  yelp-xsl = callPackage ./core/yelp-xsl { };

  zenity = callPackage ./core/zenity { };


#### Apps (http://ftp.acc.umu.se/pub/GNOME/apps/)

  accerciser = callPackage ./apps/accerciser { };

  cheese = callPackage ./apps/cheese { };

  evolution = callPackage ./apps/evolution { };

  file-roller = callPackage ./apps/file-roller { };

  gedit = callPackage ./apps/gedit { };

  ghex = callPackage ./apps/ghex { };

  glade = callPackage ./apps/glade { };

  gnome-books = callPackage ./apps/gnome-books { };

  gnome-boxes = callPackage ./apps/gnome-boxes { };

  gnome-calendar = callPackage ./apps/gnome-calendar { };

  gnome-characters = callPackage ./apps/gnome-characters { };

  gnome-clocks = callPackage ./apps/gnome-clocks { };

  gnome-documents = callPackage ./apps/gnome-documents { };

  gnome-getting-started-docs = callPackage ./apps/gnome-getting-started-docs { };

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

  libgnome-games-support = callPackage ./misc/libgnome-games-support { };

  gnome-applets = callPackage ./misc/gnome-applets { };

  gnome-flashback = callPackage ./misc/gnome-flashback { };

  gnome-panel = callPackage ./misc/gnome-panel { };

  gnome-screensaver = callPackage ./misc/gnome-screensaver { };

  gnome-tweaks = callPackage ./misc/gnome-tweaks { };

  gpaste = callPackage ./misc/gpaste { };

  metacity = callPackage ./misc/metacity { };

  nautilus-python = callPackage ./misc/nautilus-python { };

  gtkhtml = callPackage ./misc/gtkhtml { enchant = pkgs.enchant1; };

  pomodoro = callPackage ./misc/pomodoro { };

  gnome-autoar = callPackage ./misc/gnome-autoar { };

  gnome-packagekit = callPackage ./misc/gnome-packagekit { };
} // lib.optionalAttrs (config.allowAliases or true) {
#### Legacy aliases

  bijiben = gnome-notes; # added 2018-09-26
  evolution_data_server = evolution-data-server; # added 2018-02-25
  geocode_glib = pkgs.geocode-glib; # added 2018-02-25
  glib_networking = pkgs.glib-networking; # added 2018-02-25
  gnome_common = gnome-common; # added 2018-02-25
  gnome_control_center = gnome-control-center; # added 2018-02-25
  gnome_desktop = gnome-desktop; # added 2018-02-25
  gnome_keyring = gnome-keyring; # added 2018-02-25
  gnome_online_accounts = gnome-online-accounts; # added 2018-02-25
  gnome_session = gnome-session; # added 2018-02-25
  gnome_settings_daemon = gnome-settings-daemon; # added 2018-02-25
  gnome_shell = gnome-shell; # added 2018-02-25
  gnome_terminal = gnome-terminal; # added 2018-02-25
  gnome-themes-standard = gnome-themes-extra; # added 2018-03-14
  gnome_themes_standard = gnome-themes-standard; # added 2018-02-25
  gnome-tweak-tool = gnome-tweaks; # added 2018-03-21
  gsettings_desktop_schemas = gsettings-desktop-schemas; # added 2018-02-25
  libgames-support = libgnome-games-support; # added 2018-03-14
  libgnome_keyring = libgnome-keyring; # added 2018-02-25
  inherit (pkgs) rarian; # added 2018-04-25
  networkmanager_fortisslvpn = networkmanager-fortisslvpn; # added 2018-02-25
  networkmanager_iodine = networkmanager-iodine; # added 2018-02-25
  networkmanager_l2tp = networkmanager-l2tp; # added 2018-02-25
  networkmanager_openconnect = networkmanager-openconnect; # added 2018-02-25
  networkmanager_openvpn = networkmanager-openvpn; # added 2018-02-25
  networkmanager_vpnc = networkmanager-vpnc; # added 2018-02-25
  yelp_xsl = yelp-xsl; # added 2018-02-25
  yelp_tools = yelp-tools; # added 2018-02-25

  # added 2019-02-08
  inherit (pkgs) atk glib gobject-introspection gspell webkitgtk gtk3 gtkmm3
      libgtop libgudev libhttpseverywhere librsvg libsecret gdk_pixbuf gtksourceview gtksourceviewmm gtksourceview4
      easytag meld orca rhythmbox shotwell gnome-usage
      clutter clutter-gst clutter-gtk cogl gtk-vnc libdazzle libgda libgit2-glib libgxps libgdata libgepub libcroco libpeas libgee geocode-glib libgweather librest libzapojit libmediaart gfbgraph gexiv2 folks totem-pl-parser gcr gsound libgnomekbd vte vte_290 gnome-menus gdl;
  inherit (pkgs) gsettings-desktop-schemas; # added 2019-04-16
  inherit (pkgs) gnome-video-effects; # added 2019-08-19
  inherit (pkgs) gnome-online-accounts grilo grilo-plugins tracker tracker-miners gnome-photos; # added 2019-08-23
  inherit (pkgs) glib-networking; # added 2019-09-02
  inherit (pkgs) nemiver; # added 2019-09-09

  defaultIconTheme = adwaita-icon-theme;
  gtk = gtk3;
  gtkmm = gtkmm3;
  rest = librest;

  pidgin-im-gnome-shell-extension = pkgs.gnomeExtensions.pidgin-im-integration; # added 2019-08-01

  # added 2019-08-25
  corePackages = throw "gnome3.corePackages is removed since 2019-08-25: please use `services.gnome3.core-shell.enable`";
  optionalPackages = throw "gnome3.optionalPackages is removed since 2019-08-25: please use `services.gnome3.core-utilities.enable`";
  gamesPackages = throw "gnome3.gamesPackages is removed since 2019-08-25: please use `services.gnome3.games.enable`";

  nautilus-sendto = throw "nautilus-sendto is removed since 2019-09-17: abandoned upstream";

  inherit (pkgs) vala; # added 2019-10-10

  inherit (pkgs) gnome-user-docs; # added 2019-11-20

  inherit (pkgs) gegl_0_4; # added 2019-10-31

  inherit (pkgs) gjs; # added 2019-01-05

  inherit (pkgs) yelp-tools; # added 2019-11-20

  inherit (pkgs) dconf; # added 2019-11-30

  inherit (pkgs) networkmanagerapplet; # added 2019-12-12
})
