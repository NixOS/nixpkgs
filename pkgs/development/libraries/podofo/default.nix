{stdenv, fetchurl, cmake, zlib, freetype, libjpeg, libtiff, fontconfig,
openssl, libpng, lua5}:

stdenv.mkDerivation rec {
  name = "podofo-0.9.2";
  src = fetchurl {
    url = "mirror://sourceforge/podofo/${name}.tar.gz";
    sha256 = "1wx3s0718rmhdzdwyi8hgpf2s92sk3hijy8f4glrmnjpiihr2la6";
  };
  propagatedBuildInputs = [ zlib freetype libjpeg libtiff fontconfig openssl libpng ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ lua5 stdenv.gcc.libc ];
  cmakeFlags = "-DPODOFO_BUILD_SHARED=ON -DPODOFO_BUILD_STATIC=OFF";

  meta = {
    homepage = http://podofo.sourceforge.net;
    description = "A library to work with the PDF file format";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
