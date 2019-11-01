{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gmm";
  version = "5.3";

  src = fetchurl {
    url = "mirror://savannah/getfem/stable/${pname}-${version}.tar.gz";
    sha256 = "0lkjd3n0298w1dli446z320sn7mqdap8h9q31nydkbw2k7b4db46";
  };

  meta = with stdenv.lib; {
    description = "Generic C++ template library for sparse, dense and skyline matrices";
    homepage = http://getfem.org/gmm.html;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
