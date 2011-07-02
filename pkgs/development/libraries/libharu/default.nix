{ stdenv, fetchurl, zlib, libpng }:

stdenv.mkDerivation {
  name = "libharu-2.2.1";

  src = fetchurl {
    url = http://libharu.org/files/libharu-2.2.1.tar.bz2;
    sha256 = "04493rjb4z8f04p3kjvnya8phg4b0vzy3mbdbp8jfy0dhvqg4h4j";
  };

  configureFlags = "--with-zlib=${zlib} --with-png=${libpng}";

  buildInputs = [ zlib libpng ];

  meta = {
    description = "Cross platform, open source library for generating PDF files";
    homepage = http://libharu.org/wiki/Main_Page;
    license = "ZLIB/LIBPNG"; # see README.
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
