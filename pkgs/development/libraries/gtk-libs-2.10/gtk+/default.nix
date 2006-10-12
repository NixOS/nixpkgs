{ xineramaSupport ? false
, stdenv, fetchurl, pkgconfig, x11, glib, atk
, pango, perl, libtiff, libjpeg, libpng, cairo, libXinerama ? null, libXrandr
}:

assert x11.buildClientLibs;
assert xineramaSupport -> libXinerama != null;


stdenv.mkDerivation {
  name = "gtk+-2.10.1";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/gtk+-2.10.1.tar.bz2;
    md5 = "7f1d39031d50de8228211aa3230d4acd";
  };
  buildInputs = [
    pkgconfig perl libtiff libjpeg libpng cairo libXrandr
    (if xineramaSupport then libXinerama else null)
  ];
  propagatedBuildInputs = [x11 glib atk pango];
  inherit libtiff libjpeg libpng;
}
