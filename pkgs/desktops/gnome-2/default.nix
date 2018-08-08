{ callPackage, self, stdenv, gettext, gvfs, libunique, bison2, rarian
, libstartup_notification, overrides ? {} }:

let overridden = set // overrides; set = with overridden; {
  # Backward compatibility.
  gtkdoc = self.gtk-doc;
  startup_notification = libstartup_notification;
  startupnotification = libstartup_notification;
  gnomedocutils = self.gnome-doc-utils;
  gnomeicontheme = self.gnome_icon_theme;
  gnome_common = gnome-common;
  inherit rarian;

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

  libgnome = callPackage ./platform/libgnome { };

  libgnomeui = callPackage ./platform/libgnomeui { };

  libbonobo = callPackage ./platform/libbonobo { };

  libbonoboui = callPackage ./platform/libbonoboui { };

  gtkhtml = callPackage ./platform/gtkhtml { };

  gtkhtml4 = callPackage ./platform/gtkhtml/4.x.nix { };

  # Required for nautilus
  inherit (libunique);

  gtkglext = callPackage ./platform/gtkglext { };

  gtkglextmm = callPackage ./platform/gtkglextmm { };

#### DESKTOP

  gvfs = gvfs.override { gnome = self; };

  # Removed from recent GNOME releases, but still required
  scrollkeeper = callPackage ./desktop/scrollkeeper { };

  gtksourceview = callPackage ./desktop/gtksourceview { };

  gnome_icon_theme = callPackage ./desktop/gnome-icon-theme { };

  vte = callPackage ./desktop/vte { };

#### BINDINGS

  libglademm = callPackage ./bindings/libglademm { };

}; in overridden
