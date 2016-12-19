{ stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "attica-0.4.2";
  
  src = fetchurl {
    url = "mirror://kde/stable/attica/${name}.tar.bz2";
    sha256 = "1y74gsyzi70dfr9d1f1b08k130rm3jaibsppg8dv5h3211vm771v";
  };
  
  buildInputs = [ qt4 ];
  nativeBuildInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    description = "Library to access Open Collaboration Service providers";
    license = "LGPL";
    maintainers = [ maintainers.sander maintainers.urkud maintainers.phreedom ];
    inherit (qt4.meta) platforms;
  };
}
