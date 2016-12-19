{ stdenv, fetchurl, cmake, boost
}:

stdenv.mkDerivation rec {
  name = "ispike-${version}";
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/ispike/${name}.tar.gz";
    sha256 = "0khrxp43bi5kisr8j4lp9fl4r5marzf7b4inys62ac108sfb28lp";
  };

  buildInputs = [ cmake boost ];

  meta = {
    description = "Spiking neural interface between iCub and a spiking neural simulator";
    homepage = https://sourceforge.net/projects/ispike/;
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };

  
}
