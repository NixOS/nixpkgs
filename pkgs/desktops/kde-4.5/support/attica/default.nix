{stdenv, fetchurl, cmake, qt4}:

stdenv.mkDerivation rec {
  name = "attica-0.1.4";
  src = fetchurl {
    url = "mirror://kde/stable/attica/${name}.tar.bz2";
    sha256 = "0frarnrnbli3f5ji90swgw05g88w1f5777ais345wc8lkvqg9ix1";
  };
  buildInputs = [ cmake qt4 ];
  meta = with stdenv.lib; {
    description = "A library to access Open Collaboration Service providers";
    license = "LGPL";
    maintainers = [ maintainers.sander maintainers.urkud ];
    platforms = qt4.meta.platforms;
  };
}
