{ callPackage, lib, self, stdenv, gettext, overrides ? {}, pkgs }:

rec {
  inherit (pkgs) fetchurl_gnome glib gtk3 atk pango;
  gtk = gtk3;
  orbit = pkgs.gnome2.ORBit2;

  inherit (lib) lowPrio hiPrio appendToName makeOverridable;

  __overrides = overrides;

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  at_spi2_atk = lib.lowPrio (callPackage ./core/at-spi2-atk { });

  at_spi2_core = callPackage ./core/at-spi2-core { };

  gconf = callPackage ./core/gconf { };

  gcr = callPackage ./core/gcr { }; # ToDo: tests fail

  gnome_terminal = callPackage ./core/gnome-terminal { };

  gsettings_desktop_schemas = lib.lowPrio (callPackage ./core/gsettings-desktop-schemas { });

  gvfs = callPackage ./core/gvfs { };

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
