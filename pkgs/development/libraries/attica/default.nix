{ stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "attica-0.4.0";
  
  src = fetchurl {
    url = "mirror://kde/stable/attica/${name}.tar.bz2";
    sha256 = "172d1z97aw9iscq6wh23i31s4hgq7mmhr3mk4xgifqv0hjcmzyhq";
  };
  
  buildInputs = [ qt4 ];
  nativeBuildInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    description = "A library to access Open Collaboration Service providers";
    license = "LGPL";
    maintainers = [ maintainers.sander maintainers.urkud ];
    inherit (qt4.meta) platforms;
  };
}
