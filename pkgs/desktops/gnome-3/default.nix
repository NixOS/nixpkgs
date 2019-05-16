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
      pkgName = drv: (builtins.parseDrvName drv.name).name;
      namesToRemove = map pkgName packagesToRemove;
    in
      lib.filter (x: !(builtins.elem (pkgName x) namesToRemove)) packages;

  maintainers = with pkgs.lib.maintainers; [ lethalman jtojnar hedning worldofpeace ];

  corePackages = with gnome3; [
    pkgs.desktop-file-utils
    pkgs.shared-mime-info # for update-mime-database
    glib # for gsettings
    gtk3.out # for gtk-update-icon-cache
    glib-networking gvfs dconf gnome-backgrounds gnome-control-center
    gnome-menus gnome-settings-daemon gnome-shell
    gnome-themes-extra adwaita-icon-theme gnome-shell-extensions
    pkgs.hicolor-icon-theme
  ];

  optionalPackages = with gnome3; [ baobab eog epiphany evince
    gucharmap nautilus totem vino yelp gnome-bluetooth
    gnome-calculator gnome-contacts gnome-font-viewer gnome-screenshot
    gnome-system-monitor simple-scan
    gnome-terminal gnome-user-docs evolution file-roller gedit
    gnome-clocks gnome-music gnome-tweaks gnome-photos
    nautilus-sendto dconf-editor vinagre gnome-weather gnome-logs
    gnome-maps gnome-characters gnome-calendar accerciser gnome-nettool
    gnome-getting-started-docs gnome-packagekit gnome-software
    gnome-power-manager gnome-todo gnome-usage
  ];

  gamesPackages = with gnome3; [ swell-foop lightsoff iagno
    tali quadrapassel gnome-sudoku atomix aisleriot five-or-more
    four-in-a-row gnome-chess gnome-klotski gnome-mahjongg
    gnome-mines gnome-nibbles gnome-robots gnome-tetravex
    hitori gnome-taquin
  ];

  libsoup = pkgs.libsoup.override { gnomeSupport = true; };
  libchamplain = pkgs.libchamplain.override { libsoup = libsoup; };
  gnome3 = self // { recurseForDerivations = false; };
  vala = pkgs.vala_0_44;
  gegl_0_4 = pkgs.gegl_0_4.override { gtk = pkgs.gtk3; };

# ISO installer
# installerIso = callPackage ./installer.nix {};

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  adwaita-icon-theme = callPackage ./core/adwaita-icon-theme { };

  baobab = callPackage ./core/baobab { };

  caribou = callPackage ./core/caribou { };

  dconf = callPackage ./core/dconf { };
  dconf-editor = callPackage ./core/dconf-editor { };

  empathy = callPackage ./core/empathy { };

  epiphany = callPackage ./core/epiphany { };

  evince = callPackage ./core/evince { }; # ToDo: dbus would prevent compilation, enable tests

  evolution-data-server = callPackage ./core/evolution-data-server { };

  gdm = callPackage ./core/gdm { };

  gjs = callPackage ./core/gjs { };

  glib-networking = pkgs.glib-networking.override {
    inherit (pkgs) gsettings-desktop-schemas;
  };

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

  gnome-online-accounts = callPackage ./core/gnome-online-accounts { };

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

  gnome-user-docs = callPackage ./core/gnome-user-docs { };

  gnome-user-share = callPackage ./core/gnome-user-share { };

  grilo = callPackage ./core/grilo { };

  grilo-plugins = callPackage ./core/grilo-plugins { };

  gucharmap = callPackage ./core/gucharmap { };

  gvfs = pkgs.gvfs.override { gnome = gnome3; gnomeSupport = true; };

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

  networkmanagerapplet = pkgs.networkmanagerapplet.override {
    withGnome = true;
  };

  rygel = callPackage ./core/rygel { };

  simple-scan = callPackage ./core/simple-scan { };

  sushi = callPackage ./core/sushi { };

  totem = callPackage ./core/totem { };

  tracker = callPackage ./core/tracker { };

  tracker-miners = callPackage ./core/tracker-miners { };

  vino = callPackage ./core/vino { };

  yelp = callPackage ./core/yelp { };

  yelp-xsl = callPackage ./core/yelp-xsl { };

  yelp-tools = callPackage ./core/yelp-tools { };

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

  gnome-photos = callPackage ./apps/gnome-photos {
    gegl = gegl_0_4;
  };

  gnome-power-manager = callPackage ./apps/gnome-power-manager { };

  gnome-sound-recorder = callPackage ./apps/gnome-sound-recorder { };

  gnome-todo = callPackage ./apps/gnome-todo {};

  gnome-weather = callPackage ./apps/gnome-weather { };

  nautilus-sendto = callPackage ./apps/nautilus-sendto { };

  polari = callPackage ./apps/polari { };

  seahorse = callPackage ./apps/seahorse { };

  vinagre = callPackage ./apps/vinagre { };

#### Dev http://ftp.gnome.org/pub/GNOME/devtools/

  anjuta = callPackage ./devtools/anjuta { };

  devhelp = callPackage ./devtools/devhelp { };

  gnome-devel-docs = callPackage ./devtools/gnome-devel-docs { };

  nemiver = callPackage ./devtools/nemiver { };

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

  pidgin-im-gnome-shell-extension = callPackage ./misc/pidgin { };

  gtkhtml = callPackage ./misc/gtkhtml { };

  pomodoro = callPackage ./misc/pomodoro { };

  gnome-autoar = callPackage ./misc/gnome-autoar { };

  gnome-video-effects = callPackage ./misc/gnome-video-effects { };

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
      clutter clutter-gst clutter-gtk cogl gtk-vnc libdazzle libgda libgit2-glib libgxps libgdata libgepub libcroco libpeas libgee geocode-glib libgweather librest libzapojit libmediaart gfbgraph gexiv2 folks totem-pl-parser gcr gsound libgnomekbd vte vte_290 vte-ng gnome-menus gdl;
  inherit (pkgs) gsettings-desktop-schemas; # added 2019-04-16
  defaultIconTheme = adwaita-icon-theme;
  gtk = gtk3;
  gtkmm = gtkmm3;
  rest = librest;
})
