{ callPackage, pkgs, self }:

rec {
  corePackages = with gnome3; [
    pkgs.desktop_file_utils pkgs.ibus
    pkgs.shared_mime_info # for update-mime-database
    gtk3 # for gtk-update-icon-cache
    glib_networking gvfs dconf gnome-backgrounds gnome_control_center
    gnome-menus gnome_settings_daemon gnome_shell
    gnome_themes_standard defaultIconTheme
  ];

  optionalPackages = with gnome3; [ baobab empathy eog epiphany evince
    gucharmap nautilus totem vino yelp gnome-bluetooth
    gnome-calculator gnome-contacts gnome-font-viewer gnome-screenshot
    gnome-shell-extensions gnome-system-log gnome-system-monitor
    gnome_terminal gnome-user-docs bijiben evolution file-roller gedit
    gnome-clocks gnome-music gnome-tweak-tool gnome-photos
    nautilus-sendto dconf-editor
  ];

  inherit (pkgs) libsoup glib gtk2;
  inherit (pkgs.gnome2) ORBit2;
  gtk3 = pkgs.gtk3_16;
  gtkmm3 = pkgs.gtkmm3_16;
  orbit = ORBit2;
  gnome3 = self // { recurseForDerivations = false; };
  clutter = pkgs.clutter_1_22;
  clutter_gtk = pkgs.clutter_gtk_1_6.override { inherit clutter gtk3; };
  clutter-gst = pkgs.clutter-gst_3_0.override { inherit clutter; };
  cogl = pkgs.cogl_1_20;
  gtk = gtk3;
  gtkmm = gtkmm3;
  vala = pkgs.vala_0_26;
  gegl_0_3 = pkgs.gegl_0_3.override { inherit gtk; };

  # Due to gtk 3.12 -> 3.16 transition
  libcanberra_gtk3 = pkgs.libcanberra_gtk3.override { inherit gtk; }; 
  libcanberra = libcanberra_gtk3;
  ibus = pkgs.ibus.override { inherit gnome3; };
  colord-gtk = pkgs.colord-gtk.override { inherit gtk3; };
  webkitgtk24x = pkgs.webkitgtk24x.override { inherit gtk3; };
  webkitgtk = pkgs.webkitgtk.override { inherit gtk3; };
  libwnck3 = pkgs.libwnck3.override { inherit gtk3; };
  gtkspell3 = pkgs.gtkspell3.override { inherit gtk3; };
  librsvg = pkgs.librsvg.override { inherit gtk3; };
  iconnamingutils = pkgs.iconnamingutils.override { inherit librsvg; };
  libchamplain = pkgs.libchamplain.override { inherit gtk3 clutter_gtk; };
  djvulibre = pkgs.djvulibre.override { inherit librsvg; };

  version = "3.16";

# Simplify the nixos module and gnome packages
  defaultIconTheme = adwaita-icon-theme;

# Backward compatibility, must be removed in favor of defaultIconTheme
  gnome_icon_theme = adwaita-icon-theme;
  gnome_icon_theme_symbolic = adwaita-icon-theme;

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  adwaita-icon-theme = callPackage ./core/adwaita-icon-theme { };

  baobab = callPackage ./core/baobab { };

  caribou = callPackage ./core/caribou { };

  dconf = callPackage ./core/dconf { };
  dconf-editor = callPackage ./core/dconf-editor { };

  empathy = callPackage ./core/empathy { 
    webkitgtk = webkitgtk24x;
    clutter-gst = pkgs.clutter-gst;
  };

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

  networkmanager_l2tp = pkgs.networkmanager_l2tp.override {
    inherit gnome3;
  };

  networkmanagerapplet = pkgs.networkmanagerapplet.override {
    inherit gnome3 gsettings_desktop_schemas glib_networking;
  };

  rest = callPackage ./core/rest { };

  sushi = callPackage ./core/sushi {
    webkitgtk = webkitgtk24x;
    clutter-gst = pkgs.clutter-gst;
  };

  totem = callPackage ./core/totem { };

  totem-pl-parser = callPackage ./core/totem-pl-parser { };

  tracker = callPackage ./core/tracker { giflib = pkgs.giflib_5_0; };

  vte = callPackage ./core/vte { };

  vte_290 = callPackage ./core/vte/2.90.nix { };

  vte-select-text = vte.override { selectTextPatch = true; };

  vino = callPackage ./core/vino { };

  yelp = callPackage ./core/yelp { 
    webkitgtk = webkitgtk24x;
  };

  yelp_xsl = callPackage ./core/yelp-xsl { };

  yelp_tools = callPackage ./core/yelp-tools { };

  zenity = callPackage ./core/zenity { };


#### Apps (http://ftp.acc.umu.se/pub/GNOME/apps/)

  bijiben = callPackage ./apps/bijiben {
    webkitgtk = webkitgtk24x;
  };

  evolution = callPackage ./apps/evolution {
    webkitgtk = webkitgtk24x;
  };

  file-roller = callPackage ./apps/file-roller { };

  gedit = callPackage ./apps/gedit { };

  glade = callPackage ./apps/glade { };

  gnome-boxes = callPackage ./apps/gnome-boxes {
    gtkvnc = pkgs.gtkvnc.override { enableGTK3 = true; };
    spice_gtk = pkgs.spice_gtk.override { enableGTK3 = true; };
  };

  gnome-clocks = callPackage ./apps/gnome-clocks { };

  gnome-documents = callPackage ./apps/gnome-documents { };

  gnome-music = callPackage ./apps/gnome-music { };

  gnome-photos = callPackage ./apps/gnome-photos {
    gegl = gegl_0_3;
  };

  nautilus-sendto = callPackage ./apps/nautilus-sendto { };

  # scrollkeeper replacement
  rarian = callPackage ./desktop/rarian { };

  seahorse = callPackage ./apps/seahorse { };

  pomodoro = callPackage ./apps/pomodoro { };

#### Dev http://ftp.gnome.org/pub/GNOME/devtools/

  anjuta = callPackage ./devtools/anjuta { };

  gdl = callPackage ./devtools/gdl { };

#### Misc -- other packages on http://ftp.gnome.org/pub/GNOME/sources/

  geary = callPackage ./misc/geary { 
    webkitgtk = webkitgtk24x;
  };

  gfbgraph = callPackage ./misc/gfbgraph { };

  goffice = callPackage ./misc/goffice { };

  gitg = callPackage ./misc/gitg { 
    webkitgtk = webkitgtk24x;
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
