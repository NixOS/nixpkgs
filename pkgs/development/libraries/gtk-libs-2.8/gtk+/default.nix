{ xineramaSupport ? false
, stdenv, fetchurl, pkgconfig, x11, glib, atk
, pango, perl, libtiff, libjpeg, libpng, cairo, libXinerama ? null
}:

assert x11.buildClientLibs;
assert xineramaSupport -> libXinerama != null;


stdenv.mkDerivation {
  name = "gtk+-2.8.19";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.8/gtk+-2.8.19.tar.bz2;
    md5 = "1a03dbed4b794194a610e9d7eb175b06";
  };
  buildInputs = [
    pkgconfig perl libtiff libjpeg libpng cairo
    (if xineramaSupport then libXinerama else null)
  ];
  propagatedBuildInputs = [x11 glib atk pango];
  inherit libtiff libjpeg libpng;
}
