{ stdenv, fetchurl, gmp, readline, openssl, libjpeg, unixODBC, zlib
, libXinerama, libXft, libXpm, libSM, libXt, freetype, pkgconfig
, fontconfig
}:

let
  version = "6.6.5";
in
stdenv.mkDerivation {
  name = "swi-prolog-${version}";

  src = fetchurl {
    url = "http://www.swi-prolog.org/download/stable/src/pl-${version}.tar.gz";
    sha256 = "0lsa90sdnkd286xgm1amwkdhvnrpsz7imfzczrfdaw4arqk4bvkr";
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
