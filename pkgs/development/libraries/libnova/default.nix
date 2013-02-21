{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libnova-0.12.1";
	
  src = fetchurl {
    url = "mirror://sourceforge/libnova/${name}.tar.gz";
    sha256 = "0bs6c45q4qkrns36qndl8vns5gvhgpd90hi68bhah4r4hrg48lw0";
  };
  
  meta = {
    description = "Celestial Mechanics, Astrometry and Astrodynamics Library";
    homepage = http://libnova.sf.net;
  };
}
