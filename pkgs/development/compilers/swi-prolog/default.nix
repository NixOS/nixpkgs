{ stdenv, fetchurl, gmp, readline, openssl, libjpeg, unixODBC, zlib
, libXinerama, libXft, libXpm, libSM, libXt, freetype, pkgconfig
, fontconfig
}:

let
  version = "6.6.1";
in
stdenv.mkDerivation {
  name = "swi-prolog-${version}";

  src = fetchurl {
    url = "http://www.swi-prolog.org/download/stable/src/pl-${version}.tar.gz";
    sha256 = "033b7z60jd1907p9idaa3xzbid2aadhqcdwsa2g9c1c7q8fj1gy8";
  };

  buildInputs = [ gmp readline openssl libjpeg unixODBC libXinerama
    libXft libXpm libSM libXt zlib freetype pkgconfig fontconfig ];

  configureFlags = "--with-world --enable-gmp --enable-shared";

  buildFlags = "world";

  meta = {
    homepage = http://www.swi-prolog.org/;
    description = "A Prolog compiler and interpreter";
    license = "LGPL";

    hydraPlatforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
