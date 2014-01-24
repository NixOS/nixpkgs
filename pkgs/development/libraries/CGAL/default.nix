{stdenv, fetchurl, cmake, boost, gmp, mpfr
  }:

stdenv.mkDerivation rec {
  version = "4.3";
  name = "cgal-${version}";
  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/32995/CGAL-${version}.tar.xz";
    sha256 = "015vw57dmy43bf63mg3916cgcsbv9dahwv24bnmiajyanj2mhiyc";
  };

  buildInputs = [cmake boost gmp mpfr ];

  doCheck = false;

  meta = {
    description = "Computational Geometry Algorithms Library";
    homepage = "http://cgal.org/";
    platforms = with stdenv.lib.platforms;
      linux;
    maintainers = with stdenv.lib.maintainers; 
      [raskin];
  };
}

