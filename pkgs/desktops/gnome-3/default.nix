{ callPackage, self, pkgs }:

rec {
  inherit (pkgs) glib gtk2 gtk3 gnome2;
  gtk = gtk3; # just to be sure
  inherit (pkgs.gnome2) gnome_common ORBit2;
  orbit = ORBit2;


#### Overrides of libraries

  librsvg = pkgs.librsvg.override { inherit gtk2; }; # gtk2 mysteriously needed in librsvg for goffice (commented in Gentoo)
  libsoup = pkgs.libsoup_2_44;

#### Core (http://ftp.acc.umu.se/pub/GNOME/core/)

  at_spi2_atk = callPackage ./core/at-spi2-atk { };

  at_spi2_core = callPackage ./core/at-spi2-core { };

  dconf = callPackage ./core/dconf { };

  evince = callPackage ./core/evince { }; # ToDo: dbus would prevent compilation, enable tests

  gconf = callPackage ./core/gconf { };

  gcr = callPackage ./core/gcr { }; # ToDo: tests fail

  gdm = callPackage ./core/gdm { };

  gnome_icon_theme = callPackage ./core/gnome-icon-theme { };

  gnome-menus = callPackage ./core/gnome-menus { };

  gnome_keyring = callPackage ./core/gnome-keyring { };
  libgnome_keyring = callPackage ./core/libgnome-keyring { };

  gnome_online_accounts = callPackage ./core/gnome-online-accounts { };

  gnome_session = callPackage ./core/gnome-session { };

  gnome_terminal = callPackage ./core/gnome-terminal { };

  gnome_themes_standard = callPackage ./core/gnome-themes-standard { };

  gsettings_desktop_schemas = callPackage ./core/gsettings-desktop-schemas { };

  gvfs = pkgs.gvfs.override { gnome = pkgs.gnome3; };

  eog = callPackage ./core/eog { };

  libcroco = callPackage ./core/libcroco {};

  libgee = callPackage ./core/libgee { };

  libgxps = callPackage ./core/libgxps { };

  libpeas = callPackage ./core/libpeas {};

  libqmi = callPackage ./core/libqmi {};

  libgweather = callPackage ./core/libgweather { };

  libzapojit = callPackage ./core/libzapojit { };

  nautilus = callPackage ./core/nautilus { };

  rest = callPackage ./core/rest { };

  vte = callPackage ./core/vte { };

  zenity = callPackage ./core/zenity { };


#### Apps (http://ftp.acc.umu.se/pub/GNOME/apps/)

  file-roller = callPackage ./desktop/file-roller { };

  gnome_dictionary = callPackage ./desktop/gnome-dictionary { };

  gnome_desktop = callPackage ./desktop/gnome-desktop { };

  gtksourceview = callPackage ./desktop/gtksourceview { };

  # scrollkeeper replacement
  rarian = callPackage ./desktop/rarian { };


#### Misc -- other packages on http://ftp.gnome.org/pub/GNOME/sources/

  goffice = callPackage ./misc/goffice { };

  gitg = callPackage ./misc/gitg { };

  libgit2-glib = callPackage ./misc/libgit2-glib { automake = pkgs.automake111x; };

}
