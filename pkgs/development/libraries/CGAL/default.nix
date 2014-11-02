{ stdenv, fetchurl, cmake, boost, gmp, mpfr }:

stdenv.mkDerivation rec {
  version = "4.5";

  name = "cgal-${version}";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/34139/CGAL-${version}.tar.xz";
    sha256 = "00shds5yph4s09lqdrb6n60wnw9kpiwa25ghg9mbsgq3fnr8p7kr";
  };

  buildInputs = [ cmake boost boost.lib gmp mpfr ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Computational Geometry Algorithms Library";
    homepage = "http://cgal.org/";
    license = licenses.gpl3Plus; # some parts are GPLv3+, some are LGPLv3+
    platforms = platforms.linux;
    maintainers = [ maintainers.raskin ];
  };
}
