{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "gmm-3.0";

  src = fetchurl {
    url = http://download.gna.org/getfem/stable/gmm-3.0.tar.gz;
    sha256 = "1lc34w68s0rhii6caklvq2pyc3jaa4g6kza948ya8ha6rr8d1ypp";
  };

  meta = { 
    description = "Generic C++ template library for sparse, dense and skyline matrices";
    homepage = http://home.gna.org/getfem/gmm_intro.html;
    license = stdenv.lib.licenses.lgpl21Plus;
  };
}
