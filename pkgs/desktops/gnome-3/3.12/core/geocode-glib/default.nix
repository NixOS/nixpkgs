{ fetchurl, stdenv, pkgconfig, gnome3, intltool, libsoup, json_glib }:


stdenv.mkDerivation rec {
  name = "geocode-glib-3.12.2";


  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/3.12/${name}.tar.xz";
    sha256 = "5ca581a927cac3025adc2afadfdaf9a493ca887537a548aa47296bc77bcfa49e";
  };

  buildInputs = with gnome3;
    [ intltool pkgconfig glib libsoup json_glib ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
