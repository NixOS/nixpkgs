{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "judy";
  version = "1.0.5";

  src = fetchurl {
    url = "mirror://sourceforge/judy/Judy-${version}.tar.gz";
    sha256 = "1sv3990vsx8hrza1mvq3bhvv9m6ff08y4yz7swn6znszz24l0w6j";
  };

  # gcc 4.8 optimisations break judy.
  # https://sourceforge.net/p/judy/mailman/message/31995144/
  preConfigure = lib.optionalString stdenv.cc.isGNU ''
    configureFlagsArray+=("CFLAGS=-fno-strict-aliasing -fno-aggressive-loop-optimizations")
  '';

  # Disable parallel builds as manpages lack some dependencies:
  #    ../tool/jhton ext/JudyHS_funcs_3.htm | grep -v '^[   ]*$' | sed -e 's/\.C//' > man/man3/JudyHS_funcs
  #    make[2]: *** No rule to make target 'man/man3/JSLD', needed by 'all-am'.  Stop.
  # Let's wait for the upstream fix similar to https://sourceforge.net/p/judy/patches/4/
  enableParallelBuilding = false;

  meta = {
    homepage = "http://judy.sourceforge.net/";
    license = lib.licenses.lgpl21Plus;
    description =
      "State-of-the-art C library that implements a sparse dynamic array";
    platforms = lib.platforms.unix;
  };
}
