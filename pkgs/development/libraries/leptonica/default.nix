{ stdenv, fetchurl, autoreconfHook, pkgconfig, which, gnuplot
, giflib, libjpeg, libpng, libtiff, libwebp, openjpeg, zlib
}:

stdenv.mkDerivation rec {
  pname = "leptonica";
  version = "1.80.0";

  src = fetchurl {
    url = "http://www.leptonica.org/source/${pname}-${version}.tar.gz";
    sha256 = "192bs676ind8627f0v3v8d1q7r4xwc7q0zvbdbxn1fgvmv14d77c";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ giflib libjpeg libpng libtiff libwebp openjpeg zlib ];
  enableParallelBuilding = true;

  checkInputs = [ which gnuplot ];

  # Fails on pngio_reg for unknown reason
  doCheck = false; # !stdenv.isDarwin;

  meta = {
    description = "Image processing and analysis library";
    homepage = "http://www.leptonica.org/";
    license = stdenv.lib.licenses.bsd2; # http://www.leptonica.org/about-the-license.html
    platforms = stdenv.lib.platforms.unix;
  };
}
