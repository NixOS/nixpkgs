{ fetchurl, stdenv, pkgconfig, gnome3, gobjectIntrospection, spidermonkey_17, pango }:


stdenv.mkDerivation rec {
  name = "gjs-1.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/1.38/${name}.tar.xz";
    sha256 = "0xl1zc5ncaxqs5ww5j82rzqrg429l8pdapqclxiba7dxwyh6a83b";
  };

  buildInputs = with gnome3;
    [ gobjectIntrospection pkgconfig glib pango ];

  propagatedBuildInputs = [ spidermonkey_17 ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
