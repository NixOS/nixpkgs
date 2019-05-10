{ stdenv, fetchurl, fetchpatch, autoreconfHook, pkgconfig
, giflib, libjpeg, libpng, libtiff, libwebp, openjpeg, zlib
}:

stdenv.mkDerivation rec {
  name = "leptonica-${version}";
  version = "1.78.0";

  src = fetchurl {
    url = "http://www.leptonica.org/source/${name}.tar.gz";
    sha256 = "122s9b8hi93va4lgwnwrbma50x5fp740npy0s92xybd2wy0jxvg2";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ giflib libjpeg libpng libtiff libwebp openjpeg zlib ];

  meta = {
    description = "Image processing and analysis library";
    homepage = http://www.leptonica.org/;
    # Its own license: http://www.leptonica.org/about-the-license.html
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix;
  };
}
