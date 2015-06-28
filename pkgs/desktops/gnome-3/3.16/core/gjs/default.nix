{ fetchurl, stdenv, pkgconfig, gnome3, gobjectIntrospection, spidermonkey_24, pango }:

let
  majorVersion = "1.42";
in
stdenv.mkDerivation rec {
  name = "gjs-${majorVersion}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/${majorVersion}/${name}.tar.xz";
    sha256 = "0c9afb7d5be6ead5b68059596f08eb7c3902b1676ee9c8846aa8df09647dba13";
  };

  buildInputs = with gnome3;
    [ gobjectIntrospection pkgconfig glib pango ];

  propagatedBuildInputs = [ spidermonkey_24 ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
