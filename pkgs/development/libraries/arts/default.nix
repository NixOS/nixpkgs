{stdenv, fetchurl, pkgconfig, glib, kdelibs, libX11, libXext, zlib, libjpeg
, libpng, perl, qt3}:

stdenv.mkDerivation {
  name = "arts-1.5.10";

  src = fetchurl {
    url = mirror://kde/stable/3.5.10/src/arts-1.5.10.tar.bz2;
    sha256 = "0ffcm24lkgg3sm89q4zsj8za5h5d9j1195pmbjhx4hj0xcwkiqlj";
  };

  KDEDIR = kdelibs;
  
  configureFlags = ''
    --with-extra-includes=${libjpeg}/include
    --with-extra-libs=${libjpeg}/lib
    --x-includes=${libX11}/include
    --x-libraries=${libX11}/lib
    --disable-dependency-tracking
    --enable-final
  '';

  nativeBuildInputs = [ pkgconfig perl ];

  buildInputs =
    [glib kdelibs libX11 libXext zlib libjpeg libpng qt3];

  meta = {
    homepage = http://www.arts-project.org/;
  };
}
