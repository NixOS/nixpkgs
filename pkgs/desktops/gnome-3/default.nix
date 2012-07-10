{ callPackage, lib, self, stdenv, gettext, overrides ? {} }:

{

  inherit (lib) lowPrio hiPrio appendToName makeOverridable;

  __overrides = overrides;

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  at_spi2_atk = callPackage ./core/at-spi2-atk { };

  at_spi2_core = callPackage ./core/at-spi2-core { };

  atk = callPackage ./core/atk { };

  gconf = callPackage ./core/gconf { };

  gdk_pixbuf = callPackage ./core/gdk-pixbuf { };

  glib = callPackage ./core/glib { };

  gobject_introspection = callPackage ./core/gobject-introspection { };

  gtk = callPackage ./core/gtk { };

  gnome_terminal = callPackage ./core/gnome-terminal { };

  gsettings_desktop_schemas = lib.lowPrio (callPackage ./core/gsettings-desktop-schemas { });

  pango = callPackage ./core/pango { };

  vte = callPackage ./core/vte { };

  zenity = callPackage ./core/zenity { };

#### Apps (http://ftp.acc.umu.se/pub/GNOME/apps/)

  gnome_dictionary = callPackage ./desktop/gnome-dictionary { };

  gnome_desktop = callPackage ./desktop/gnome-desktop { };

  # Removed from recent GNOME releases, but still required
  scrollkeeper = callPackage ./desktop/scrollkeeper { };

  # scrollkeeper replacement
  rarian = callPackage ./desktop/rarian { };

}
