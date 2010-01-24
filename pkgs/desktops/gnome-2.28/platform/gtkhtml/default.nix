{ stdenv, fetchurl, pkgconfig, gtk, intltool,
GConf, enchant, isocodes, gnome_icon_theme }:

stdenv.mkDerivation rec {
  name = "gtkhtml-3.29.5";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/3.29/${name}.tar.bz2";
    sha256 = "0abd91isqbriq9nclq14275v2xd0r9vrr3sxhxwxxp02m8gskwvd";
  };

  buildInputs = [pkgconfig gtk intltool GConf enchant isocodes gnome_icon_theme ];
}
