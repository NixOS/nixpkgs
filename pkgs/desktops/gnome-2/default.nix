{ callPackage, self, stdenv, gettext, gvfs, libunique, bison2
, libstartup_notification, overrides ? {} }:

let overridden = set // overrides; set = with overridden; {
  # Backward compatibility.
  gtkdoc = self.gtk-doc;
  startup_notification = libstartup_notification;
  startupnotification = libstartup_notification;
  gnomedocutils = self.gnome-doc-utils;
  gnomeicontheme = self.gnome_icon_theme;
  gnomepanel = self.gnome_panel;
  gnome_common = gnome-common;
  gnome_keyring = gnome-keyring;
  gnome_desktop = gnome-desktop;
  gnome_settings_daemon = gnome-settings-daemon;
  gnome_control_center = gnome-control-center;

#### PLATFORM

  libIDL = callPackage ./platform/libIDL {
    gettext = if stdenv.isDarwin then gettext else null;
  };

  ORBit2 = callPackage ./platform/ORBit2 { };

  libart_lgpl = callPackage ./platform/libart_lgpl { };

  libglade = callPackage ./platform/libglade { };

  libgnomeprint = callPackage ./platform/libgnomeprint {
    bison = bison2;
  };

  libgnomeprintui = callPackage ./platform/libgnomeprintui { };

  libgnomecups = callPackage ./platform/libgnomecups { };

  libgtkhtml = callPackage ./platform/libgtkhtml { };

  GConf = callPackage ./platform/GConf { };

  gconfmm = callPackage ./platform/gconfmm { };

  libgnomecanvas = callPackage ./platform/libgnomecanvas { };

  libgnomecanvasmm = callPackage ./platform/libgnomecanvasmm { };

  # for git-head builds
  gnome-common = callPackage platform/gnome-common { };

  gnome_mime_data = callPackage ./platform/gnome-mime-data { };

  gnome_python = callPackage ./bindings/gnome-python { };

  gnome_python_desktop = callPackage ./bindings/gnome-python-desktop { };
  python_rsvg = overridden.gnome_python_desktop;

  gnome_vfs = callPackage ./platform/gnome-vfs { };

  gnome_vfs_monikers = callPackage ./platform/gnome-vfs-monikers { };

  libgnome = callPackage ./platform/libgnome { };

  libgnomeui = callPackage ./platform/libgnomeui { };

  libbonobo = callPackage ./platform/libbonobo { };

  libbonoboui = callPackage ./platform/libbonoboui { };

  at_spi = callPackage ./platform/at-spi { };

  gtkhtml = callPackage ./platform/gtkhtml { };

  gtkhtml4 = callPackage ./platform/gtkhtml/4.x.nix { };

  # Required for nautilus
  inherit (libunique);

  gtkglext = callPackage ./platform/gtkglext { };

  gtkglextmm = callPackage ./platform/gtkglextmm { };

#### DESKTOP

  gnome-keyring = callPackage ./desktop/gnome-keyring { };

  libgweather = callPackage ./desktop/libgweather { };

  gvfs = gvfs.override { gnome = self; };

  libgnomekbd = callPackage ./desktop/libgnomekbd { };

  # Removed from recent GNOME releases, but still required
  scrollkeeper = callPackage ./desktop/scrollkeeper { };

  # scrollkeeper replacement
  rarian = callPackage ./desktop/rarian { };

  zenity = callPackage ./desktop/zenity { };

  metacity = callPackage ./desktop/metacity { };

  gnome_menus = callPackage ./desktop/gnome-menus { };

  gnome-desktop = callPackage ./desktop/gnome-desktop { };

  gnome_panel = callPackage ./desktop/gnome-panel { };

  gnome-settings-daemon = callPackage ./desktop/gnome-settings-daemon { };

  gnome-control-center = callPackage ./desktop/gnome-control-center { };

  gtksourceview = callPackage ./desktop/gtksourceview { };

  gnome_icon_theme = callPackage ./desktop/gnome-icon-theme { };

  vte = callPackage ./desktop/vte { };

#### BINDINGS

  libglademm = callPackage ./bindings/libglademm { };

}; in overridden
