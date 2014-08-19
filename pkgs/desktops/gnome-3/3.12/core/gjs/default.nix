{ fetchurl, stdenv, pkgconfig, gnome3, gobjectIntrospection, spidermonkey_24, pango }:


stdenv.mkDerivation rec {
  name = "gjs-1.40.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gjs/1.40/${name}.tar.xz";
    sha256 = "2f0d80ec96c6284785143abe51377d8a284977ea6c3cf0cef1020d92eae41793";
  };

  buildInputs = with gnome3;
    [ gobjectIntrospection pkgconfig glib pango ];

  propagatedBuildInputs = [ spidermonkey_24 ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
