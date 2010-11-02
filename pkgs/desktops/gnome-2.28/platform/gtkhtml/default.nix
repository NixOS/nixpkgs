{ stdenv, fetchurl, pkgconfig, gtk, intltool,
GConf, enchant, isocodes, gnome_icon_theme }:

stdenv.mkDerivation rec {
  name = "gtkhtml-3.29.92.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/3.29/${name}.tar.bz2";
    sha256 = "a34fe24af0f591db95010475c21a461985ef4479b2e91602bc745a9accfeef77";
  };

  buildInputs = [pkgconfig gtk intltool GConf enchant isocodes gnome_icon_theme ];
}
