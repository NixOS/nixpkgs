{stdenv, fetchurl, cmake, zlib, freetype, libjpeg, libtiff, fontconfig,
openssl, libpng, lua5}:

stdenv.mkDerivation rec {
  name = "podofo-0.8.2";
  src = fetchurl {
    url = "mirror://sourceforge/podofo/${name}.tar.gz";
    sha256 = "064cgrvjvy57n5i25d4j7yx5wd3wgkdks448bzc3a8nsmyl08skq";
  };
  propagatedBuildInputs = [ zlib freetype libjpeg libtiff fontconfig openssl libpng ];
  buildInputs = [ cmake lua5 stdenv.gcc.libc ];
  cmakeFlags = "-DPODOFO_BUILD_SHARED=ON -DPODOFO_BUILD_STATIC=OFF";

  meta = {
    homepage = http://podofo.sourceforge.net;
    description = "A library to work with the PDF file format";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
