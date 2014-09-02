{ stdenv, fetchurl, cmake, boost, gmp, mpfr }:

stdenv.mkDerivation rec {
  version = "4.4";

  name = "cgal-${version}";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/33526/CGAL-${version}.tar.xz";
    sha256 = "1s0ylyrx74vgw6vsg6xxk4b07jrxh8pqcmxcbkx46v01nczv3ixj";
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
