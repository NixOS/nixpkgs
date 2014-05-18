{ fetchurl, stdenv, pkgconfig, gnome3, intltool, libsoup, json_glib }:


stdenv.mkDerivation rec {
  name = "geocode-glib-3.10.0";


  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/3.10/${name}.tar.xz";
    sha256 = "0dx6v9n4dsskcy6630s77cyb32xlykdall0d555976warycc3v8a";
  };

  buildInputs = with gnome3;
    [ intltool pkgconfig glib libsoup json_glib ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
