{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, which, gnuplot
, giflib, libjpeg, libpng, libtiff, libwebp, openjpeg, zlib
}:

stdenv.mkDerivation rec {
  pname = "leptonica";
  version = "1.82.0";

  src = fetchurl {
    url = "http://www.leptonica.org/source/${pname}-${version}.tar.gz";
    sha256 = "sha256-FVMC7pFGaMJ7b+PKn/LaY7JF9tYvMGHI8nVjd0uK4tY=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ giflib libjpeg libpng libtiff libwebp openjpeg zlib ];
  enableParallelBuilding = true;

  nativeCheckInputs = [ which gnuplot ];

  # Fails on pngio_reg for unknown reason
  doCheck = false; # !stdenv.isDarwin;

  meta = {
    description = "Image processing and analysis library";
    homepage = "http://www.leptonica.org/";
    license = lib.licenses.bsd2; # http://www.leptonica.org/about-the-license.html
    platforms = lib.platforms.unix;
  };
}
