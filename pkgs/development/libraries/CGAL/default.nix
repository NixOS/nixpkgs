{ stdenv, fetchurl, cmake, boost, gmp, mpfr, mesa_glu }:

stdenv.mkDerivation rec {
  version = "4.7";
  name = "cgal-" + version;

  src = fetchurl {
    url = "https://github.com/CGAL/releases/archive/CGAL-${version}.tar.gz";
    sha256 = "1hbp4qpfqvpggvv79yxr6z3w7y0nwd31zavb1s57y55yl9z3zfxy";
  };

  # note: optional component libCGAL_ImageIO would need zlib and opengl;
  #   there are also libCGAL_Qt{3,4} omitted ATM
  buildInputs = [ cmake boost gmp mpfr ];
  #propagatedBuildInputs = [ mesa_glu ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Computational Geometry Algorithms Library";
    homepage = http://cgal.org;
    license = licenses.gpl3Plus; # some parts are GPLv3+, some are LGPLv3+
    platforms = platforms.all;
    maintainers = [ maintainers.raskin ];
  };
}
