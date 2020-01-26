{ stdenv, fetchurl, autoreconfHook, pkgconfig, which, gnuplot
, giflib, libjpeg, libpng, libtiff, libwebp, openjpeg, zlib
}:

stdenv.mkDerivation rec {
  pname = "leptonica";
  version = "1.79.0";

  src = fetchurl {
    url = "http://www.leptonica.org/source/${pname}-${version}.tar.gz";
    sha256 = "1n004gv1dj3pq1fcnfdclvvx5nang80336aa67nvs3nnqp4ncn84";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ giflib libjpeg libpng libtiff libwebp openjpeg zlib ];
  enableParallelBuilding = true;

  checkInputs = [ which gnuplot ];

  # Fails on pngio_reg for unknown reason
  doCheck = false; # !stdenv.isDarwin;

  meta = {
    description = "Image processing and analysis library";
    homepage = http://www.leptonica.org/;
    license = stdenv.lib.licenses.bsd2; # http://www.leptonica.org/about-the-license.html
    platforms = stdenv.lib.platforms.unix;
  };
}
