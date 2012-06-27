{stdenv, fetchurl, libpng12, libtiff, libjpeg, zlib}:

stdenv.mkDerivation {
  name = "leptonica-1.68";
  
  src = fetchurl {
    url = http://www.leptonica.org/source/leptonica-1.68.tar.gz;
    sha256 = "13qzm24zy46bj9b476jxzbw9qh7p96jikfzxg88kz4dj1p2vdvxc";
  };

  buildInputs = [ libpng12 libtiff libjpeg zlib ];

  meta = {
    description = "Image processing and analysis library";
    homepage = http://www.leptonica.org/;
    # Its own license: http://www.leptonica.org/about-the-license.html
    license = "free";
  };
}
