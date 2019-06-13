{ stdenv, fetchzip, cmake, zlib, libpng }:

stdenv.mkDerivation {
  name = "libharu-2.3.0";

  src = fetchzip {
    url = https://github.com/libharu/libharu/archive/RELEASE_2_3_0.tar.gz;
    sha256 = "15s9hswnl3qqi7yh29jyrg0hma2n99haxznvcywmsp8kjqlyg75q";
  };

  buildInputs = [ zlib libpng cmake ];

  meta = {
    description = "Cross platform, open source library for generating PDF files";
    homepage = http://libharu.org/;
    license = stdenv.lib.licenses.zlib;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.unix;
  };
}
