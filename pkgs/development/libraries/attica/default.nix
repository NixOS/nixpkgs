{ stdenv, fetchurl, cmake, qt4 }:

stdenv.mkDerivation rec {
  name = "attica-0.2.0";
  
  src = fetchurl {
    url = "mirror://kde/stable/attica/${name}.tar.bz2";
    sha256 = "0g2la91fgdr185ah15vc91plvdwvbm6kpsyz0vk0da7ggiyg3y9a";
  };
  
  buildInputs = [ cmake qt4 ];
  
  meta = with stdenv.lib; {
    description = "A library to access Open Collaboration Service providers";
    license = "LGPL";
    maintainers = [ maintainers.sander maintainers.urkud ];
    platforms = qt4.meta.platforms;
  };
}
