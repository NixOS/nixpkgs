{stdenv, fetchurl, cmake, boost, gmp, mpfr
  }:

stdenv.mkDerivation rec {
  version = "4.3";
  name = "cgal-${version}";
  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/29125/CGAL-${version}.tar.gz";
    sha256 = "193vjhzlf7f2kw6dbg5yw8v0izdvmnrylqzqhw92vml7jjnr8494";
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

