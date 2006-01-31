{ stdenv, fetchurl, libX11, libXt, libXext, zlib, perl, qt, openssl, pcre
, pkgconfig, libjpeg, libpng, libtiff, libxml2, libxslt, libtool, expat
, freetype
}:

stdenv.mkDerivation {
  name = "kdelibs-3.5.0";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.kde.org/pub/kde/stable/3.5/src/kdelibs-3.5.0.tar.bz2;
    md5 = "2b11d654e2ea1a3cd16dcfdcbb7d1915";
  };

  inherit openssl libX11 libjpeg;
  buildInputs = [
    libX11 libXt libXext zlib perl qt openssl pcre 
    pkgconfig libjpeg libpng libtiff libxml2 libxslt expat
    libtool freetype
  ];
}
