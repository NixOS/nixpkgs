{ config, stdenv, pkgs, lib }:

lib.makeScope pkgs.newScope (self: with self; {

#### PLATFORM

  libIDL = callPackage ./platform/libIDL {
    gettext = if stdenv.isDarwin then pkgs.gettext else null;
  };

  ORBit2 = callPackage ./platform/ORBit2 { };

  libart_lgpl = callPackage ./platform/libart_lgpl { };

  libglade = callPackage ./platform/libglade { };

  libgnomeprint = callPackage ./platform/libgnomeprint { };

  libgnomeprintui = callPackage ./platform/libgnomeprintui { };

  libgnomecups = callPackage ./platform/libgnomecups { };

  libgtkhtml = callPackage ./platform/libgtkhtml { };

  GConf = callPackage ./platform/GConf { };

  libgnomecanvas = callPackage ./platform/libgnomecanvas { };

  libgnomecanvasmm = callPackage ./platform/libgnomecanvasmm { };

  # for git-head builds
  gnome-common = callPackage platform/gnome-common { };

  gnome_mime_data = callPackage ./platform/gnome-mime-data { };

  gnome_python = callPackage ./bindings/gnome-python { };

  gnome_python_desktop = callPackage ./bindings/gnome-python-desktop { };

  gnome_vfs = callPackage ./platform/gnome-vfs { };

  libgnome = callPackage ./platform/libgnome { };

  libgnomeui = callPackage ./platform/libgnomeui { };

  libbonobo = callPackage ./platform/libbonobo { };

  libbonoboui = callPackage ./platform/libbonoboui { };

  gtkhtml = callPackage ./platform/gtkhtml { enchant = pkgs.enchant1; };

  gtkhtml4 = callPackage ./platform/gtkhtml/4.x.nix { enchant = pkgs.enchant2; };

  gtkglext = callPackage ./platform/gtkglext { };

#### DESKTOP

  # Removed from recent GNOME releases, but still required
  scrollkeeper = callPackage ./desktop/scrollkeeper { };

  gtksourceview = callPackage ./desktop/gtksourceview {
    autoreconfHook = pkgs.autoreconfHook269;
  };

} // lib.optionalAttrs (config.allowAliases or true) {
  inherit (pkgs)
    # GTK Libs
    glib glibmm atk atkmm cairo pango pangomm gdk_pixbuf gtkmm2 libcanberra-gtk2

    # Included for backwards compatibility
    libsoup libwnck2 gtk-doc gnome-doc-utils rarian

    gvfs # added 2019-09-03
  ;

  gtk = pkgs.gtk2;
  gtkmm = pkgs.gtkmm2;
  python_rsvg = self.gnome_python_desktop;

  gtkdoc = pkgs.gtk-doc;
  startup_notification = pkgs.libstartup_notification;
  startupnotification = pkgs.libstartup_notification;
  gnomedocutils = pkgs.gnome-doc-utils;
  gnome-icon-theme = pkgs.gnome-icon-theme;
  gnome_icon_theme = self.gnome-icon-theme;
  gnomeicontheme = self.gnome-icon-theme;
  gnome_common = gnome-common;
  libglademm = throw "libglademm has been removed"; # 2022-01-15
})
