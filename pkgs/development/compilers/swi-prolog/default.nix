{ stdenv, fetchurl, gmp, readline, openssl, libjpeg, unixODBC, zlib,
   libXinerama, libXft, libXpm, libSM, libXt, freetype, pkgconfig,
   fontconfig }:

let
  version = "6.4.1";
in
stdenv.mkDerivation {
  name = "swi-prolog-${version}";

  src = fetchurl {
    url = "http://www.swi-prolog.org/download/stable/src/pl-${version}.tar.gz";
    sha256 = "1szqqwypqfd0qr3sk0qlip1ar22kpqgba6b44klmr1aag0lrahs8";
  };

  buildInputs = [gmp readline openssl libjpeg unixODBC libXinerama
    libXft libXpm libSM libXt zlib freetype pkgconfig fontconfig];
  configureFlags = "--with-world --enable-gmp --enable-shared";
  makeFlags = "world";

  meta = {
    homepage = http://www.swi-prolog.org/;
    description = "A Prolog compiler and interpreter";
    license = "LGPL";

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
