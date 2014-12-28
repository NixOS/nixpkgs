{ callPackage, pkgs }:

rec {
  inherit (pkgs) glib gtk2 gtk3 gnome2;
  gnome3 = pkgs.gnome3_12 // { recurseForDerivations = false; };

  # DO NOT UPGRADE CLUTTER, IT BREAKS GNOME 3.12
  clutter = pkgs.clutter_1_18;
  clutter_gtk = pkgs.clutter_gtk.override { inherit clutter; };
  clutter-gst = pkgs.clutter-gst.override { inherit clutter; };
  cogl = pkgs.cogl_1_18;

  gtk = gtk3; # just to be sure
  libcanberra = pkgs.libcanberra_gtk3; # just to be sure
  inherit (pkgs.gnome2) ORBit2;
  orbit = ORBit2;
  inherit (pkgs) libsoup;

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  baobab = callPackage ./core/baobab { };

  caribou = callPackage ./core/caribou { };

  dconf = callPackage ./core/dconf { };

  empathy = callPackage ./core/empathy {
    webkitgtk = pkgs.webkitgtk24x;
  };

  epiphany = callPackage ./core/epiphany {
    webkitgtk = pkgs.webkitgtk24x;
  };

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

  gnome-contacts = callPackage ./core/gnome-contacts { };

  gnome_control_center = callPackage ./core/gnome-control-center { };

  gnome-calculator = callPackage ./core/gnome-calculator { };

  gnome_common = callPackage ./core/gnome-common { };

  gnome_desktop = callPackage ./core/gnome-desktop { };

  gnome-dictionary = callPackage ./core/gnome-dictionary { };

  gnome-disk-utility = callPackage ./core/gnome-disk-utility { };

  gnome-font-viewer = callPackage ./core/gnome-font-viewer { };

  gnome_icon_theme = callPackage ./core/gnome-icon-theme { };

  gnome_icon_theme_symbolic = callPackage ./core/gnome-icon-theme-symbolic { };

  gnome-menus = callPackage ./core/gnome-menus { };

  gnome_keyring = callPackage ./core/gnome-keyring { };

  libgnome_keyring = callPackage ./core/libgnome-keyring { };

  libgnomekbd = callPackage ./core/libgnomekbd { };

  folks = callPackage ./core/folks { };

  gnome_online_accounts = callPackage ./core/gnome-online-accounts {
    webkitgtk = pkgs.webkitgtk24x;
  };

  gnome-online-miners = callPackage ./core/gnome-online-miners { };

  gnome_session = callPackage ./core/gnome-session { };

  gnome_shell = callPackage ./core/gnome-shell { };

  gnome-shell-extensions = callPackage ./core/gnome-shell-extensions { };

  gnome-screenshot = callPackage ./core/gnome-screenshot { };

  gnome_settings_daemon = callPackage ./core/gnome-settings-daemon { };

  gnome-system-log = callPackage ./core/gnome-system-log { };

  gnome-system-monitor = callPackage ./core/gnome-system-monitor { };

  gnome_terminal = callPackage ./core/gnome-terminal { };

  gnome_themes_standard = callPackage ./core/gnome-themes-standard { };

  gnome-user-docs = callPackage ./core/gnome-user-docs { };

  gnome-user-share = callPackage ./core/gnome-user-share { };

  grilo = callPackage ./core/grilo { };

  grilo-plugins = callPackage ./core/grilo-plugins { };

  gsettings_desktop_schemas = callPackage ./core/gsettings-desktop-schemas { };

  gtksourceview = callPackage ./core/gtksourceview { };

  gucharmap = callPackage ./core/gucharmap { };

  gvfs = pkgs.gvfs.override { gnome = gnome3; gnomeSupport = true; };

  eog = callPackage ./core/eog { };

  libcroco = callPackage ./core/libcroco {};

  libgee = callPackage ./core/libgee { };

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

  networkmanagerapplet = pkgs.networkmanagerapplet.override {
    inherit gnome3 gsettings_desktop_schemas glib_networking
      networkmanager_openvpn networkmanager_pptp networkmanager_vpnc
      networkmanager_openconnect;
  };

  rest = callPackage ./core/rest { };

  sushi = callPackage ./core/sushi {
    webkitgtk = pkgs.webkitgtk24x;
  };

  totem = callPackage ./core/totem { };

  totem-pl-parser = callPackage ./core/totem-pl-parser { };

  tracker = callPackage ./core/tracker { giflib = pkgs.giflib_5_0; };

  vte = callPackage ./core/vte { };

  vte_038 = callPackage ./core/vte/0.38.0.nix { }; # To be moved in gnome 3.14 when available

  vte-select-text = vte_038.override { selectTextPatch = true; };

  vino = callPackage ./core/vino { };

  yelp = callPackage ./core/yelp {
    webkitgtk = pkgs.webkitgtk24x;
  };

  yelp_xsl = callPackage ./core/yelp-xsl { };

  yelp_tools = callPackage ./core/yelp-tools { };

  zenity = callPackage ./core/zenity { };


#### Apps (http://ftp.acc.umu.se/pub/GNOME/apps/)

  bijiben = callPackage ./apps/bijiben {
    webkitgtk = pkgs.webkitgtk24x;
  };

  evolution = callPackage ./apps/evolution {
    webkitgtk = pkgs.webkitgtk24x;
  };

  file-roller = callPackage ./apps/file-roller { };

  gedit = callPackage ./apps/gedit { };

  glade = callPackage ./apps/glade { };

  gnome-boxes = callPackage ./apps/gnome-boxes {
    gtkvnc = pkgs.gtkvnc.override { enableGTK3 = true; };
    spice_gtk = pkgs.spice_gtk.override { enableGTK3 = true; };
  };

  gnome-clocks = callPackage ./apps/gnome-clocks { };

  gnome-documents = callPackage ./apps/gnome-documents {
    webkitgtk = pkgs.webkitgtk24x;
  };

  gnome-music = callPackage ./apps/gnome-music { };

  gnome-photos = callPackage ./apps/gnome-photos { };

  nautilus-sendto = callPackage ./apps/nautilus-sendto { };

  # scrollkeeper replacement
  rarian = callPackage ./desktop/rarian { };

  seahorse = callPackage ./apps/seahorse { };

  polari = callPackage ./apps/polari { };

  pomodoro = callPackage ./apps/pomodoro { };

#### Dev http://ftp.gnome.org/pub/GNOME/devtools/

  anjuta = callPackage ./devtools/anjuta { };

  gdl = callPackage ./devtools/gdl { };

#### Misc -- other packages on http://ftp.gnome.org/pub/GNOME/sources/

  geary = callPackage ./misc/geary {
    webkitgtk = pkgs.webkitgtk24x;
  };

  gfbgraph = callPackage ./misc/gfbgraph { };

  goffice = callPackage ./misc/goffice { };

  gitg = callPackage ./misc/gitg {
    webkitgtk = pkgs.webkitgtk24x;
  };

  libgda = callPackage ./misc/libgda { };

  libgit2-glib = callPackage ./misc/libgit2-glib {
    libgit2 = pkgs.libgit2.override { libssh2 = null; };
  };

  libmediaart = callPackage ./misc/libmediaart { };

  gexiv2 = callPackage ./misc/gexiv2 { };

  gnome-tweak-tool = callPackage ./misc/gnome-tweak-tool { };

  gpaste = callPackage ./misc/gpaste { };

  gtkhtml = callPackage ./misc/gtkhtml { };

}
