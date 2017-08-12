{ pkgs }:

let

  pkgsFun = overrides:
    let
      self = self_ // overrides;
      self_ = with self; {

  overridePackages = f:
    let newself = pkgsFun (f newself self);
    in newself;

  callPackage = pkgs.newScope self;

  version = "3.22";
  maintainers = with pkgs.lib.maintainers; [ lethalman ];

  corePackages = with gnome3; [
    pkgs.desktop_file_utils pkgs.ibus
    pkgs.shared_mime_info # for update-mime-database
    glib # for gsettings
    gtk3.out # for gtk-update-icon-cache
    glib_networking gvfs dconf gnome-backgrounds gnome_control_center
    gnome-menus gnome_settings_daemon gnome_shell
    gnome_themes_standard defaultIconTheme gnome-shell-extensions
    pkgs.hicolor_icon_theme
  ];

  optionalPackages = with gnome3; [ baobab eog epiphany evince
    gucharmap nautilus totem vino yelp gnome-bluetooth
    gnome-calculator gnome-contacts gnome-font-viewer gnome-screenshot
    gnome-system-log gnome-system-monitor
    gnome_terminal gnome-user-docs evolution file-roller gedit
    gnome-clocks gnome-music gnome-tweak-tool gnome-photos
    nautilus-sendto dconf-editor vinagre gnome-weather gnome-logs
    gnome-maps gnome-characters gnome-calendar accerciser gnome-nettool
    gnome-getting-started-docs gnome-packagekit gnome-software
  ];

  gamesPackages = with gnome3; [ swell-foop lightsoff iagno
    tali quadrapassel gnome-sudoku aisleriot five-or-more
    four-in-a-row gnome-chess gnome-klotski gnome-mahjongg
    gnome-mines gnome-nibbles gnome-robots gnome-tetravex
    hitori gnome-taquin
  ];

  inherit (pkgs) glib gtk2 webkitgtk216x gtk3 gtkmm3 libcanberra_gtk2
    clutter clutter-gst clutter_gtk cogl gtkvnc;
  inherit (pkgs.gnome2) ORBit2;
  libsoup = pkgs.libsoup.override { gnomeSupport = true; };
  libchamplain = pkgs.libchamplain.override { libsoup = libsoup; };
  orbit = ORBit2;
  gnome3 = self // { recurseForDerivations = false; };
  gtk = gtk3;
  gtkmm = gtkmm3;
  vala = pkgs.vala_0_32;
  gegl_0_3 = pkgs.gegl_0_3.override { inherit gtk; };
  webkitgtk = webkitgtk216x;

# Simplify the nixos module and gnome packages
  defaultIconTheme = adwaita-icon-theme;

# ISO installer
# installerIso = callPackage ./installer.nix {};

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  adwaita-icon-theme = callPackage ./core/adwaita-icon-theme { };

  baobab = callPackage ./core/baobab { };

  caribou = callPackage ./core/caribou { };

  dconf = callPackage ./core/dconf { };
  dconf-editor = callPackage ./core/dconf-editor { };

  # empathy = callPackage ./core/empathy {
  #   webkitgtk = webkitgtk24x-gtk3;
  #   clutter-gst = pkgs.clutter-gst;
  # };

  epiphany = callPackage ./core/epiphany { };

  evince = callPackage ./core/evince { }; # ToDo: dbus would prevent compilation, enable tests

  evolution_data_server = callPackage ./core/evolution-data-server { };

  gconf = callPackage ./core/gconf { };

  geocode_glib = callPackage ./core/geocode-glib { };

  gcr = callPackage ./core/gcr { }; # ToDo: tests fail

  gdm = callPackage ./core/gdm { };

  gjs = callPackage ./core/gjs { };

  glib_networking = pkgs.glib_networking.override {
    inherit gsettings_desktop_schemas;
  };

  gnome-backgrounds = callPackage ./core/gnome-backgrounds { };

  gnome-bluetooth = callPackage ./core/gnome-bluetooth { };

  gnome-contacts = callPackage ./core/gnome-contacts { };

  gnome_control_center = callPackage ./core/gnome-control-center { };

  gnome-calculator = callPackage ./core/gnome-calculator { };

  gnome_common = callPackage ./core/gnome-common { };

  gnome_desktop = callPackage ./core/gnome-desktop { };

  gnome-dictionary = callPackage ./core/gnome-dictionary { };

  gnome-disk-utility = callPackage ./core/gnome-disk-utility { };

  gnome-font-viewer = callPackage ./core/gnome-font-viewer { };

  gnome-menus = callPackage ./core/gnome-menus { };

  gnome_keyring = callPackage ./core/gnome-keyring { };

  libgnome_keyring = callPackage ./core/libgnome-keyring { };

  libgnomekbd = callPackage ./core/libgnomekbd { };

  folks = callPackage ./core/folks { };

  gnome_online_accounts = callPackage ./core/gnome-online-accounts { };

  gnome-online-miners = callPackage ./core/gnome-online-miners { };

  gnome_session = callPackage ./core/gnome-session { };

  gnome_shell = callPackage ./core/gnome-shell { };

  gnome-shell-extensions = callPackage ./core/gnome-shell-extensions { };

  gnome-screenshot = callPackage ./core/gnome-screenshot { };

  gnome_settings_daemon = callPackage ./core/gnome-settings-daemon { };

  gnome-software = callPackage ./core/gnome-software { };

  gnome-system-log = callPackage ./core/gnome-system-log { };

  gnome-system-monitor = callPackage ./core/gnome-system-monitor { };

  gnome_terminal = callPackage ./core/gnome-terminal { };

  gnome_themes_standard = callPackage ./core/gnome-themes-standard { };

  gnome-user-docs = callPackage ./core/gnome-user-docs { };

  gnome-user-share = callPackage ./core/gnome-user-share { };

  grilo = callPackage ./core/grilo { };

  grilo-plugins = callPackage ./core/grilo-plugins { };

  gsettings_desktop_schemas = callPackage ./core/gsettings-desktop-schemas { };

  gsound = callPackage ./core/gsound { };

  gtksourceview = callPackage ./core/gtksourceview { };

  gtksourceviewmm = callPackage ./core/gtksourceviewmm { };

  gucharmap = callPackage ./core/gucharmap { };

  gvfs = pkgs.gvfs.override { gnome = gnome3; gnomeSupport = true; };

  eog = callPackage ./core/eog { };

  libcroco = callPackage ./core/libcroco {};

  libgee = callPackage ./core/libgee { };

  libgepub = callPackage ./core/libgepub { };

  libgdata = callPackage ./core/libgdata { };

  libgxps = callPackage ./core/libgxps { };

  libpeas = callPackage ./core/libpeas {};

  libgweather = callPackage ./core/libgweather { };

  libzapojit = callPackage ./core/libzapojit { };

  mutter = callPackage ./core/mutter { };

  nautilus = callPackage ./core/nautilus { };

  networkmanager_openvpn = pkgs.networkmanager_openvpn.override {
    inherit gnome3;
  };

  networkmanager_pptp = pkgs.networkmanager_pptp.override {
    inherit gnome3;
  };

  networkmanager_vpnc = pkgs.networkmanager_vpnc.override {
    inherit gnome3;
  };

  networkmanager_openconnect = pkgs.networkmanager_openconnect.override {
    inherit gnome3;
  };

  networkmanager_fortisslvpn = pkgs.networkmanager_fortisslvpn.override {
    inherit gnome3;
  };

  networkmanager_l2tp = pkgs.networkmanager_l2tp.override {
    inherit gnome3;
  };

  networkmanagerapplet = pkgs.networkmanagerapplet.override {
    inherit gnome3 gsettings_desktop_schemas glib_networking;
  };

  rest = callPackage ./core/rest { };

  sushi = callPackage ./core/sushi { };

  totem = callPackage ./core/totem { };

  totem-pl-parser = callPackage ./core/totem-pl-parser { };

  tracker = callPackage ./core/tracker { giflib = pkgs.giflib_5_0; };

  vte = callPackage ./core/vte { };

  vte_290 = callPackage ./core/vte/2.90.nix { };

  vte-ng = callPackage ./core/vte/ng.nix { };

  vino = callPackage ./core/vino { };

  yelp = callPackage ./core/yelp { };

  yelp_xsl = callPackage ./core/yelp-xsl { };

  yelp_tools = callPackage ./core/yelp-tools { };

  zenity = callPackage ./core/zenity { };


#### Apps (http://ftp.acc.umu.se/pub/GNOME/apps/)

  accerciser = callPackage ./apps/accerciser { };

  bijiben = callPackage ./apps/bijiben {
    # https://bugzilla.gnome.org/show_bug.cgi?id=728293
    webkitgtk = pkgs.webkitgtk24x-gtk3;
  };

  cheese = callPackage ./apps/cheese { };

  evolution = callPackage ./apps/evolution { };

  file-roller = callPackage ./apps/file-roller { };

  gedit = callPackage ./apps/gedit { };

  ghex = callPackage ./apps/ghex { };

  glade = callPackage ./apps/glade { };

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

  gnome-photos = callPackage ./apps/gnome-photos {
    gegl = gegl_0_3;
  };

  gnome-weather = callPackage ./apps/gnome-weather { };

  nautilus-sendto = callPackage ./apps/nautilus-sendto { };

  polari = callPackage ./apps/polari { };

  # scrollkeeper replacement
  rarian = callPackage ./desktop/rarian { };

  seahorse = callPackage ./apps/seahorse { };

  vinagre = callPackage ./apps/vinagre { };

#### Dev http://ftp.gnome.org/pub/GNOME/devtools/

  anjuta = callPackage ./devtools/anjuta { };

  devhelp = callPackage ./devtools/devhelp { };

  gdl = callPackage ./devtools/gdl { };

  gnome-devel-docs = callPackage ./devtools/gnome-devel-docs { };

  nemiver = callPackage ./devtools/nemiver { };

#### Games

  aisleriot = callPackage ./games/aisleriot { };

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

  california = callPackage ./misc/california { };

  geary = callPackage ./misc/geary {
    # https://bugzilla.gnome.org/show_bug.cgi?id=728002
    webkitgtk = pkgs.webkitgtk24x-gtk3;
  };

  gfbgraph = callPackage ./misc/gfbgraph { };

  gitg = callPackage ./misc/gitg { };

  gspell = callPackage ./misc/gspell { };

  libgames-support = callPackage ./misc/libgames-support { };

  libgda = callPackage ./misc/libgda { };

  libgit2-glib = callPackage ./misc/libgit2-glib { };

  libmediaart = callPackage ./misc/libmediaart { };

  gexiv2 = callPackage ./misc/gexiv2 { };

  gnome-tweak-tool = callPackage ./misc/gnome-tweak-tool { };

  gpaste = callPackage ./misc/gpaste { };

  pidgin-im-gnome-shell-extension = callPackage ./misc/pidgin { };

  gtkhtml = callPackage ./misc/gtkhtml { };

  pomodoro = callPackage ./misc/pomodoro { };

  gnome-autoar = callPackage ./misc/gnome-autoar { };

  gnome-video-effects = callPackage ./misc/gnome-video-effects { };

  gnome-packagekit = callPackage ./misc/gnome-packagekit { };

    };
  in self; # pkgsFun

in pkgsFun {}
