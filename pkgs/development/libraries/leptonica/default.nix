{ lib, stdenv, fetchurl, autoreconfHook, pkg-config, which, gnuplot
, giflib, libjpeg, libpng, libtiff, libwebp, openjpeg, zlib
}:

stdenv.mkDerivation rec {
  pname = "leptonica";
  version = "1.83.0";

  src = fetchurl {
    url = "http://www.leptonica.org/source/${pname}-${version}.tar.gz";
    sha256 = "sha256-IGWR3VjPhO84CDba0TO1jJ0a+SSR9amCXDRqFiBEvP4=";
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
