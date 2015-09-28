{ fetchurl, stdenv, pkgconfig, gnome3, intltool, libsoup, json_glib }:


stdenv.mkDerivation rec {
  name = "geocode-glib-${gnome3.version}.0";


  src = fetchurl {
    url = "mirror://gnome/sources/geocode-glib/${gnome3.version}/${name}.tar.xz";
    sha256 = "1cbfv0kds6b6k0cl7q47xpj3x1scwcd7m68zl1rf7i4hmhw4hpqj";
  };

  buildInputs = with gnome3;
    [ intltool pkgconfig glib libsoup json_glib ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = gnome3.maintainers;
  };

}
