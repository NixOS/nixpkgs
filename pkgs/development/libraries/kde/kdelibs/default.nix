{ stdenv, fetchurl, libX11, libXt, libXext, zlib, perl, qt, openssl, pcre
, pkgconfig, libjpeg, libpng, libtiff, libxml2, libxslt, libtool, expat
, freetype, bzip2
}:

stdenv.mkDerivation {
  name = "kdelibs-3.5.0";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/kdelibs-3.5.0.tar.bz2;
    md5 = "2b11d654e2ea1a3cd16dcfdcbb7d1915";
  };

  inherit openssl libX11 libjpeg;
  buildInputs = [
    libX11 libXt libXext zlib perl qt openssl pcre 
    pkgconfig libjpeg libpng libtiff libxml2 libxslt expat
    libtool freetype bzip2
  ];

  configureFlags="
    --without-arts 
    --with-ssl-dir=${openssl}
    --with-extra-includes=${libjpeg}/include
    --x-includes=${libX11}/include
    --x-libraries=${libX11}/lib
  ";
}
