{ stdenv, fetchurl, zlib, libpng }:

stdenv.mkDerivation {
  name = "haru-2.1.0";

  src = fetchurl {
    url = http://libharu.org/files/libharu-2.1.0.tar.bz2;
    sha256 = "07mbvw41jwrapc8jwhi385jpr5b3wx6kah41mkxkifvc06y2141r";
  };

  configureFlags = "--with-zlib=${zlib} --with-png=${libpng}";

  buildInputs = [ zlib libpng ];

  meta = { 
    description = "cross platform, open source library for generating PDF files";
    homepage = http://libharu.org/wiki/Main_Page;
    license = "ZLIB/LIBPNG"; # see README.
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
