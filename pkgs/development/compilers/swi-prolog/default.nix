{ stdenv, fetchurl, gmp, readline, openssl, libjpeg, unixODBC, zlib, 
   libXinerama, libXft, libXpm, libSM, libXt, freetype, pkgconfig,
   fontconfig }:

stdenv.mkDerivation rec {
  version = "5.10.2";
  name = "swi-prolog-${version}";

  src = fetchurl {
    url = "http://www.swi-prolog.org/download/stable/src/pl-${version}.tar.gz";
    sha256 = "1a3ebbcd649f429a41b64561d38423692e00524c29227432d0eb5a0e24e2a4c9";
  };

  buildInputs = [gmp readline openssl libjpeg unixODBC libXinerama 
    libXft libXpm libSM libXt zlib freetype pkgconfig fontconfig];
  configureFlags = "--with-world --enable-gmp --enable-shared";
  makeFlags = "world";

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${freetype}/include/freetype2"
  '';

  meta = {
    homepage = http://www.swi-prolog.org/;
    description = "A Prolog compiler and interpreter";
    license = "LGPL";
  };
}
