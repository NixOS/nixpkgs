{ xineramaSupport ? false
, stdenv, fetchurl, pkgconfig, x11, glib, atk
, pango, perl, libtiff, libjpeg, libpng, cairo, libXinerama ? null
}:

assert x11.buildClientLibs;
assert xineramaSupport -> libXinerama != null;


stdenv.mkDerivation {
  name = "gtk+-2.10.0";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.10/gtk+-2.10.0.tar.bz2;
    md5 = "37cdf73719e8b2af6b0d065df6236542";
  };
  buildInputs = [
    pkgconfig perl libtiff libjpeg libpng cairo
    (if xineramaSupport then libXinerama else null)
  ];
  propagatedBuildInputs = [x11 glib atk pango];
  inherit libtiff libjpeg libpng;
}
