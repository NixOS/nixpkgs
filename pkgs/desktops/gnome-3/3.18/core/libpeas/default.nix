{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, glib, gtk3, gobjectIntrospection, python3, python3Packages, ncurses
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  configureFlags = [ "--enable-python3" ];

  buildInputs =  [
   intltool pkgconfig glib gtk3 gobjectIntrospection python3 python3Packages.pygobject3
   gnome3.defaultIconTheme ncurses
  ];

  meta = with stdenv.lib; {
    description = "A GObject-based plugins engine";
    homepage = "http://ftp.acc.umu.se/pub/GNOME/sources/libpeas/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
