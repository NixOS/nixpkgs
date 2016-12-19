{stdenv, fetchurl, libpng, libtiff, libjpeg, zlib}:

stdenv.mkDerivation {
  name = "leptonica-1.72";

  src = fetchurl {
    url = http://www.leptonica.org/source/leptonica-1.72.tar.gz;
    sha256 = "0mhzvqs0im04y1cpcc1yma70hgdac1frf33h73m9z3356bfymmbr";
  };

  buildInputs = [ libpng libtiff libjpeg zlib ];

  meta = {
    description = "Image processing and analysis library";
    homepage = http://www.leptonica.org/;
    # Its own license: http://www.leptonica.org/about-the-license.html
    license = stdenv.lib.licenses.free;
    platforms = stdenv.lib.platforms.unix;
  };
}
