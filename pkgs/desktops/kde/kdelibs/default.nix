{ stdenv, fetchurl, libX11, libXt, libXext, zlib, perl, qt, openssl, pcre
, pkgconfig, libjpeg, libpng, libtiff, libxml2, libxslt, libtool, expat
, freetype, bzip2, cups
}:

let version = "3.5.9"; in

stdenv.mkDerivation {
  name = "kdelibs-${version}";
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/kdelibs-${version}.tar.bz2";
    md5 = "55e5f00874933d1a7ba7c95e369a205e";
  };

  passthru = {inherit openssl libX11 libjpeg qt;};
  
  buildInputs = [
    libX11 libXt libXext zlib perl qt openssl pcre 
    pkgconfig libjpeg libpng libtiff libxml2 libxslt expat
    libtool freetype bzip2 cups
  ];

  configureFlags = ''
    --without-arts 
    --with-ssl-dir=${openssl}
    --with-extra-includes=${libjpeg}/include
    --x-includes=${libX11}/include
    --x-libraries=${libX11}/lib
  '';
}
