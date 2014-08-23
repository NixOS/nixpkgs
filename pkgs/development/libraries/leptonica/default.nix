{stdenv, fetchurl, libpng, libtiff, libjpeg, zlib}:

stdenv.mkDerivation {
  name = "leptonica-1.69";

  src = fetchurl {
    url = http://www.leptonica.org/source/leptonica-1.69.tar.gz;
    sha256 = "0bd7w0zpmwwfn1cnrlyzjw3jf8x59r0rhdmvk7rigr57rnfnddry";
  };

  buildInputs = [ libpng libtiff libjpeg zlib ];

  meta = {
    description = "Image processing and analysis library";
    homepage = http://www.leptonica.org/;
    # Its own license: http://www.leptonica.org/about-the-license.html
    license = "free";
  };
}
