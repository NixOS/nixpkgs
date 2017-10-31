{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "gmm-${version}";
  version = "5.1";

  src = fetchurl {
    url ="http://download.gna.org/getfem/stable/${name}.tar.gz";
    sha256 = "0di68vdn34kznf96rnwrpb3bbm3ahaczwxd306s9dx41kcqbzrlh";
  };

  meta = with stdenv.lib; {
    description = "Generic C++ template library for sparse, dense and skyline matrices";
    homepage = http://home.gna.org/getfem/gmm_intro.html;
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
  };
}
