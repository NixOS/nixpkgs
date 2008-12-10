{stdenv, fetchurl, pkgconfig, glib, kdelibs, libX11, libXext, zlib, libjpeg, libpng, perl, qt}:

stdenv.mkDerivation {
  name = "arts-1.5.4";

  KDEDIR = kdelibs;
  configureFlags = "
    --with-extra-includes=${libjpeg}/include
    --with-extra-libs=${libjpeg}/lib
    --x-includes=${libX11}/include
    --x-libraries=${libX11}/lib";

  src = fetchurl {
    url = http://nixos.org/tarballs/arts-1.5.4.tar.bz2;
    md5 = "886ba4a13dc0da312d94c09f50c3ffe6";
  };

  buildInputs = [pkgconfig glib kdelibs libX11 libXext zlib libjpeg libpng perl qt];

}


