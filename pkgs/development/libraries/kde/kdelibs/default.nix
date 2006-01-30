{stdenv, fetchurl, libX11, libXt, libXext, zlib, perl, qt, openssl, pcre,
 pkgconfig, libjpeg, libpng, libtiff, libxml2, libxslt, libtool, expat,
 freetype}:

stdenv.mkDerivation {
  name = "kdelibs-3.4.3";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/kdelibs-3.4.3.tar.bz2;
    md5 = "0cd7c0c8a81e5d11b91b407a4aaaf3ff";
  };

  inherit openssl libX11 libjpeg;
  buildInputs = [
    libX11 libXt libXext zlib perl qt openssl pcre 
    pkgconfig libjpeg libpng libtiff libxml2 libxslt expat libtool freetype
  ];
}
