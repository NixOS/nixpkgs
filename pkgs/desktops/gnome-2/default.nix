{ callPackage, self, stdenv, gettext, gvfs, overrides ? {} }:
{
  __overrides = overrides;

  # Backward compatibility.
  gtkdoc = self.gtk_doc;
  startupnotification = self.startup_notification;
  gnomedocutils = self.gnome_doc_utils;
  gnomeicontheme = self.gnome_icon_theme;
  gnomepanel = self.gnome_panel;

#### PLATFORM

  libIDL = callPackage ./platform/libIDL {
    gettext = if stdenv.isDarwin then gettext else null;
  };

  ORBit2 = callPackage ./platform/ORBit2 { };

  libart_lgpl = callPackage ./platform/libart_lgpl { };

  libglade = callPackage ./platform/libglade { };

  libgnomeprint = callPackage ./platform/libgnomeprint { };

  libgnomeprintui = callPackage ./platform/libgnomeprintui { };

  libgnomecups = callPackage ./platform/libgnomecups { };

  libgtkhtml = callPackage ./platform/libgtkhtml { };

  GConf = callPackage ./platform/GConf { };

  gconfmm = callPackage ./platform/gconfmm { };

  libgnomecanvas = callPackage ./platform/libgnomecanvas { };

  libgnomecanvasmm = callPackage ./platform/libgnomecanvasmm { };

  # for git-head builds
  gnome_common = callPackage platform/gnome-common { };

  gnome_mime_data = callPackage ./platform/gnome-mime-data { };

  gnome_python = callPackage ./bindings/gnome-python { };

  gnome_vfs = callPackage ./platform/gnome-vfs { };

  gnome_vfs_monikers = callPackage ./platform/gnome-vfs-monikers { };

  libgnome = callPackage ./platform/libgnome { };

  libgnomeui = callPackage ./platform/libgnomeui { };

  libbonobo = callPackage ./platform/libbonobo { };

  libbonoboui = callPackage ./platform/libbonoboui { };

  python_rsvg = callPackage ./bindings/python-rsvg { };

  at_spi = callPackage ./platform/at-spi { };

  gtkhtml = callPackage ./platform/gtkhtml { };


  # Freedesktop library
  startup_notification = callPackage ./platform/startup-notification { };

  # Required for nautilus
  libunique = callPackage ./platform/libunique { };

  gtkglext = callPackage ./platform/gtkglext { };

  gtkglextmm = callPackage ./platform/gtkglextmm { };

#### DESKTOP

  gnome_keyring = callPackage ./desktop/gnome-keyring { };

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

  gnome_desktop = callPackage ./desktop/gnome-desktop { };

  gnome_panel = callPackage ./desktop/gnome-panel { };

  gnome_session = callPackage ./desktop/gnome-session { };

  gnome_settings_daemon = callPackage ./desktop/gnome-settings-daemon { };

  gnome_control_center = callPackage ./desktop/gnome-control-center { };

  gtksourceview = callPackage ./desktop/gtksourceview { };

  nautilus = callPackage ./desktop/nautilus { };

  gnome_icon_theme = callPackage ./desktop/gnome-icon-theme { };

  vte = callPackage ./desktop/vte { };

#### BINDINGS

  libglademm = callPackage ./bindings/libglademm { };

}
