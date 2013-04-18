{ stdenv, fetchurl, gmp, readline, openssl, libjpeg, unixODBC, zlib,
   libXinerama, libXft, libXpm, libSM, libXt, freetype, pkgconfig,
   fontconfig }:

let
  version = "6.2.6";
in
stdenv.mkDerivation {
  name = "swi-prolog-${version}";

  src = fetchurl {
    url = "http://www.swi-prolog.org/download/stable/src/pl-${version}.tar.gz";
    sha256 = "0ii14ghmky91kkh017khahl00s4igkz03b5gy6y0vhv179sz04ll";
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

    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
