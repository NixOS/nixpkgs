{stdenv, fetchurl, pkgconfig, glib, kdelibs, libX11, libXext, zlib, libjpeg, libpng, perl, qt}:

stdenv.mkDerivation {
  name = "arts-1.5.10";

  KDEDIR = kdelibs;
  configureFlags = "
    --with-extra-includes=${libjpeg}/include
    --with-extra-libs=${libjpeg}/lib
    --x-includes=${libX11}/include
    --x-libraries=${libX11}/lib";

  src = fetchurl {
    url = mirror://kde/stable/3.5.10/src/arts-1.5.10.tar.bz2;
    md5 = "6da172aab2a4a44929b5fdfc30fa3efc";
  };

  buildInputs = [pkgconfig glib kdelibs libX11 libXext zlib libjpeg libpng perl qt];

}


