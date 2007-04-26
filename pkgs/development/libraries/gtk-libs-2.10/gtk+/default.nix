{ xineramaSupport ? false
, stdenv, fetchurl, pkgconfig, x11, glib, atk
, pango, perl, libtiff, libjpeg, libpng, cairo, libXinerama ? null, libXrandr
}:

assert x11.buildClientLibs;
assert xineramaSupport -> libXinerama != null;


stdenv.mkDerivation {
  name = "gtk+-2.10.11";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.10/gtk+-2.10.11.tar.bz2;
    md5 = "3b32eab43bf5195d981867d25ba55d66";
  };
  buildInputs = [
    pkgconfig perl libtiff libjpeg libpng cairo libXrandr
    (if xineramaSupport then libXinerama else null)
  ];
  propagatedBuildInputs = [x11 glib atk pango];
  inherit libtiff libjpeg libpng;
}
