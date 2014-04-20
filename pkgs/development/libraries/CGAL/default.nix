{ stdenv, fetchurl, cmake, boost, gmp, mpfr }:

stdenv.mkDerivation rec {
  version = "4.3";

  name = "cgal-${version}";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/32995/CGAL-${version}.tar.xz";
    sha256 = "015vw57dmy43bf63mg3916cgcsbv9dahwv24bnmiajyanj2mhiyc";
  };

  buildInputs = [ cmake boost gmp mpfr ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Computational Geometry Algorithms Library";
    homepage = "http://cgal.org/";
    license = licenses.gpl3Plus; # some parts are GPLv3+, some are LGPLv3+
    platforms = platforms.linux;
    maintainers = [ maintainers.raskin ];
  };
}
