{ stdenv, fetchurl, libX11, libXt, libXext, zlib, perl, qt, openssl, pcre
, pkgconfig, libjpeg, libpng, libtiff, libxml2, libxslt, libtool, expat
, freetype, bzip2
}:

stdenv.mkDerivation {
  name = "kdelibs-3.5.6";
  
  src = fetchurl {
    url = http://ftp.scarlet.be/pub/kde/stable/3.5.6/src/kdelibs-3.5.6.tar.bz2;
    sha256 = "0p0v4gr61qlvnpg9937chrjh3s7xi3nn7wvrg1xjf8dfqq164xh6";
  };

  passthru = {inherit openssl libX11 libjpeg;};
  
  buildInputs = [
    libX11 libXt libXext zlib perl qt openssl pcre 
    pkgconfig libjpeg libpng libtiff libxml2 libxslt expat
    libtool freetype bzip2
  ];

  configureFlags = "
    --without-arts 
    --with-ssl-dir=${openssl}
    --with-extra-includes=${libjpeg}/include
    --x-includes=${libX11}/include
    --x-libraries=${libX11}/lib
  ";
}
