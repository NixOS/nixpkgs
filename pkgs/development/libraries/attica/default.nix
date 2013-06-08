{ stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "attica-0.4.1";
  
  src = fetchurl {
    url = "mirror://kde/stable/attica/${name}.tar.bz2";
    sha256 = "1rnd861vy6waf25b1ilsr3rwb06dmmlnd8zq3l8y6r0lq5i2bl9n";
  };
  
  buildInputs = [ qt4 ];
  nativeBuildInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    description = "A library to access Open Collaboration Service providers";
    license = "LGPL";
    maintainers = [ maintainers.sander maintainers.urkud maintainers.phreedom ];
    inherit (qt4.meta) platforms;
  };
}
