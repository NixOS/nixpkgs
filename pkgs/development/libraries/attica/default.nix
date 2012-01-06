{ stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "attica-0.3.0";
  
  src = fetchurl {
    url = "mirror://kde/stable/attica/${name}.tar.bz2";
    sha256 = "1wfd37mvskn77ppzjdh3x6cb5p9na81ibh05ardfvbwqqn523gd0";
  };
  
  buildInputs = [ qt4 ];
  buildNativeInputs = [ cmake ];
  
  meta = with stdenv.lib; {
    description = "A library to access Open Collaboration Service providers";
    license = "LGPL";
    maintainers = [ maintainers.sander maintainers.urkud ];
    inherit (qt4.meta) platforms;
  };
}
