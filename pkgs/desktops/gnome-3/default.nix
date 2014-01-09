{ callPackage, self, pkgs }:

rec {
  inherit (pkgs) glib gtk2 gtk3 gnome2;
  gtk = gtk3; # just to be sure
  inherit (pkgs.gnome2) gnome_common ORBit2;
  orbit = ORBit2;


#### Overrides of libraries

  librsvg = pkgs.librsvg.override { inherit gtk2; }; # gtk2 mysteriously needed in librsvg for goffice (commented in Gentoo)


#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  at_spi2_atk = callPackage ./core/at-spi2-atk { };

  at_spi2_core = callPackage ./core/at-spi2-core { };

  evince = callPackage ./core/evince { }; # ToDo: dbus would prevent compilation, enable tests

  gconf = callPackage ./core/gconf { };

  gcr = callPackage ./core/gcr { }; # ToDo: tests fail

  gnome_icon_theme = callPackage ./core/gnome-icon-theme { };

  gnome-menus = callPackage ./core/gnome-menus { };

  gnome_keyring = callPackage ./core/gnome-keyring { };
  libgnome_keyring = callPackage ./core/libgnome-keyring { };

  gnome_terminal = callPackage ./core/gnome-terminal { };

  gnome_themes_standard = callPackage ./core/gnome-themes-standard { };

  gsettings_desktop_schemas = callPackage ./core/gsettings-desktop-schemas { };

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


#### Misc -- other packages on http://ftp.gnome.org/pub/GNOME/sources/

  goffice = callPackage ./misc/goffice { };

}
