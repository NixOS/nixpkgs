{ xineramaSupport ? false
, stdenv, fetchurl, pkgconfig, x11, glib, atk
, pango, perl, libtiff, libjpeg, libpng, cairo, libXinerama ? null, libXrandr
}:

assert x11.buildClientLibs;
assert xineramaSupport -> libXinerama != null;


stdenv.mkDerivation {
  name = "gtk+-2.10.9";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v2.10/gtk+-2.10.9.tar.bz2;
    md5 = "20d763198efb38263b22dee347f69da6";
  };
  buildInputs = [
    pkgconfig perl libtiff libjpeg libpng cairo libXrandr
    (if xineramaSupport then libXinerama else null)
  ];
  propagatedBuildInputs = [x11 glib atk pango];
  inherit libtiff libjpeg libpng;
}
