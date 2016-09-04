{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libcdaudio-0.99.12";
  src = fetchurl {
    url = mirror://sourceforge/libcdaudio/libcdaudio-0.99.12.tar.gz ;
    md5 = "63b49cf14d53eed31e7a87cca17a3963" ;
  };

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
