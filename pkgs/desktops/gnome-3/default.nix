{ callPackage, lib, self, stdenv, gettext, overrides ? {}, pkgs }:

rec {
  inherit (pkgs) fetchurl_gnome glib gtk3 atk pango;
  gtk = gtk3;
  inherit (pkgs.gnome2) gnome_common ORBit2;
  orbit = ORBit2;

  inherit (lib) lowPrio hiPrio appendToName makeOverridable;

  __overrides = overrides;

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  at_spi2_atk = callPackage ./core/at-spi2-atk { };

  at_spi2_core = callPackage ./core/at-spi2-core { };

  evince = callPackage ./core/evince { }; # ToDo: dbus would prevent compilation, enable tests

  gconf = callPackage ./core/gconf { };

  gcr = callPackage ./core/gcr { }; # ToDo: tests fail

  gnome_icon_theme = callPackage ./core/gnome-icon-theme { };

  gnome_keyring = callPackage ./core/gnome-keyring { };
  libgnome_keyring = callPackage ./core/libgnome-keyring { };

  gnome_terminal = callPackage ./core/gnome-terminal { };

  gsettings_desktop_schemas = lib.lowPrio (callPackage ./core/gsettings-desktop-schemas { });

  gvfs = pkgs.gvfs.override { gnome = pkgs.gnome3; };

  libcroco = callPackage ./core/libcroco {};

  libgweather = callPackage ./core/libgweather { };

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
