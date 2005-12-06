{ xineramaSupport ? false
, stdenv, fetchurl, pkgconfig, x11, glib, atk
, pango, perl, libtiff, libjpeg, libpng, cairo, libXinerama ? null
}:

assert x11.buildClientLibs;
assert xineramaSupport -> libXinerama != null;


stdenv.mkDerivation {
  name = "gtk+-2.8.8";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/gtk+-2.8.8.tar.bz2;
    md5 = "a048757bbe37f74d0de065aa0ac29c52";
  };
  buildInputs = [
    pkgconfig perl libtiff libjpeg libpng cairo
    (if xineramaSupport then libXinerama else null)
  ];
  propagatedBuildInputs = [x11 glib atk pango];
  inherit libtiff libjpeg libpng;
}
