{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "gmm";
  version = "5.4";

  src = fetchurl {
    url = "mirror://savannah/getfem/stable/${pname}-${version}.tar.gz";
    sha256 = "0mhygfpsdyr0d4h3sn6g7nxn149yrlqv7r2h34yqkrpv1q4daqvi";
  };

  meta = with stdenv.lib; {
    description = "Generic C++ template library for sparse, dense and skyline matrices";
    homepage = "http://getfem.org/gmm.html";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
