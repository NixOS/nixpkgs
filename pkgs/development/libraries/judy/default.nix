{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "judy-1.0.5";

  src = fetchurl {
    url = mirror://sourceforge/judy/Judy-1.0.5.tar.gz;
    sha256 = "1sv3990vsx8hrza1mvq3bhvv9m6ff08y4yz7swn6znszz24l0w6j";
  };

  # gcc 4.8 optimisations break judy.
  # http://sourceforge.net/p/judy/mailman/message/31995144/
  preConfigure = stdenv.lib.optionalString stdenv.cc.isGNU ''
    configureFlagsArray+=("CFLAGS=-fno-strict-aliasing -fno-aggressive-loop-optimizations")
  '';

  meta = {
    homepage = http://judy.sourceforge.net/;
    license = stdenv.lib.licenses.lgpl21Plus;
    description = "State-of-the-art C library that implements a sparse dynamic array";
    platforms = stdenv.lib.platforms.unix;
  };
}
