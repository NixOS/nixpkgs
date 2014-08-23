{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libnova-0.12.3";
	
  src = fetchurl {
    url = "mirror://sourceforge/libnova/${name}.tar.gz";
    sha256 = "18mkx79gyhccp5zqhf6k66sbhv97s7839sg15534ijajirkhw9dc";
  };
  
  meta = {
    description = "Celestial Mechanics, Astrometry and Astrodynamics Library";
    homepage = http://libnova.sf.net;
  };
}
