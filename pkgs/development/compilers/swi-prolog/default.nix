{ stdenv, fetchurl, gmp, readline, openssl, libjpeg, unixODBC, zlib, libXinerama, libXft, libXpm, libSM, libXt }:

stdenv.mkDerivation rec {
  version = "5.10.2";
  name = "swi-prolog-${version}";

  src = fetchurl {
    url = "http://www.swi-prolog.org/download/stable/src/pl-${version}.tar.gz";
    sha256 = "1a3ebbcd649f429a41b64561d38423692e00524c29227432d0eb5a0e24e2a4c9";
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
