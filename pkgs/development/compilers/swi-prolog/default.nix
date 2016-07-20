{ stdenv, fetchurl, gmp, readline, openssl, libjpeg, unixODBC, zlib
, libXinerama, libXft, libXpm, libSM, libXt, freetype, pkgconfig
, fontconfig
}:

let
  version = "6.6.6";
in
stdenv.mkDerivation {
  name = "swi-prolog-${version}";

  src = fetchurl {
    url = "http://www.swi-prolog.org/download/stable/src/pl-${version}.tar.gz";
    sha256 = "0vcrfskm2hyhv30lxr6v261myb815jc3bgmcn1lgsc9g9qkvp04z";
  };

  buildInputs = [ gmp readline openssl libjpeg unixODBC libXinerama
    libXft libXpm libSM libXt zlib freetype pkgconfig fontconfig ];

  hardeningDisable = [ "format" ];

  configureFlags = "--with-world --enable-gmp --enable-shared";

  buildFlags = "world";

  meta = {
    homepage = http://www.swi-prolog.org/;
    description = "A Prolog compiler and interpreter";
    license = "LGPL";

    hydraPlatforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.peti ];
  };
}
