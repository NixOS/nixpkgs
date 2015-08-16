{ stdenv, fetchurl, cmake, boost, gmp, mpfr }:

stdenv.mkDerivation rec {
  version = "4.6.1";

  name = "cgal-${version}";

  src = fetchurl {
    url = "https://github.com/CGAL/releases/archive/releases/CGAL-${version}.tar.gz";
    sha256 = "09ph5qi7ixbkk3jssq3pdjf2nyw91s73dizi2mkx6brhrzd1zd5y";
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
