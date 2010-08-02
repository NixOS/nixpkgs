{ stdenv, fetchurl, gfortran }:

stdenv.mkDerivation {
  name = "atlas-3.9.11";
  
  src = fetchurl {
    url = mirror://sf/math-atlas/atlas3.9.11.tar.bz2;
    sha256 = "d91e593a772cf540ff693f7d8c43d10c3037eb334c5c77572ea1b6a64a0b9677";
  };

  # configure outside of the source directory
  preConfigure = '' mkdir build; cd build; configureScript=../configure; '';

  # the manual says you should pass -fPIC as configure arg .. It works
  configureFlags = "-Fa alg -fPIC";

  buildInputs = [ gfortran ];

  meta = {
    description = "Atlas library";
    license = "GPL";
    homepage = http://math-atlas.sourceforge.net/;
  };
}
