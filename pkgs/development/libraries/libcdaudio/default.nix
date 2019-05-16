{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libcdaudio-0.99.12";
  src = fetchurl {
    url = mirror://sourceforge/libcdaudio/libcdaudio-0.99.12.tar.gz ;
    sha256 = "1g3ba1n12g8h7pps0vlxx8di6cmf108mbcvbl6hj8x71ndkglygb" ;
  };

  meta = {
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.lgpl2;
  };
}
