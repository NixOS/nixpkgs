{ stdenv, fetchurl, cmake, boost, gmp, mpfr }:

stdenv.mkDerivation rec {
  version = "4.4";

  name = "cgal-${version}";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/32995/CGAL-${version}.tar.xz";
    md5 = "c0af5e3a56300b0c92ebd3a1f0df9149";
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
