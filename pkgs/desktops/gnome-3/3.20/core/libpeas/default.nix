{ stdenv, fetchurl, pkgconfig, intltool, gnome3
, glib, gtk3, gobjectIntrospection, python, pygobject3
}:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  buildInputs =  [
   intltool pkgconfig glib gtk3 gobjectIntrospection python pygobject3
   gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    description = "A GObject-based plugins engine";
    homepage = "http://ftp.acc.umu.se/pub/GNOME/sources/libpeas/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };
}
