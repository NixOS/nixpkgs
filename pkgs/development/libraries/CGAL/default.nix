{ stdenv, fetchurl, cmake, boost, gmp, mpfr }:

stdenv.mkDerivation rec {
  version = "4.6.1";

  name = "cgal-${version}";

  src = fetchurl {
    url = "https://github.com/CGAL/releases/archive/CGAL-${version}.tar.gz";
    sha256 = "05vk4l62d7g6cz19q36h1an5krxdbgq1fbs5hi0x2l7blsja1z6g";
  };

  # note: optional component libCGAL_ImageIO would need zlib and opengl;
  #   there are also libCGAL_Qt{3,4} omitted ATM
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
