{ stdenv, fetchurl, gmp, readline, openssl, libjpeg, unixODBC, zlib, libXinerama, libXft, libXpm, libSM, libXt }:

stdenv.mkDerivation {
  name = "swi-prolog-5.6.64";

  src = fetchurl {
    url = "http://gollem.science.uva.nl/cgi-bin/nph-download/SWI-Prolog/pl-5.6.64.tar.gz";
    sha256 = "b0e70c3c02b7753ed440359746e7729d21c93e42689c1f0f32b148167b1b2c66";
  };

  buildInputs = [gmp readline openssl libjpeg unixODBC libXinerama libXft libXpm libSM libXt zlib];
  configureFlags = "--with-world --enable-gmp --enable-shared";
  makeFlags = "world";

  meta = {
    homepage = http://www.swi-prolog.org/;
    description = "A Prolog compiler and interpreter";
    license = "LGPL";
  };
}
