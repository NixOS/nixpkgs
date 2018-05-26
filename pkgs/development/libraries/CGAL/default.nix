{ stdenv, fetchFromGitHub, cmake, boost, gmp, mpfr }:

stdenv.mkDerivation rec {
  version = "4.12";
  name = "cgal-" + version;

  src = fetchFromGitHub {
    owner = "CGAL";
    repo = "releases";
    rev = "CGAL-${version}";
    sha256 = "0n4yvg2rkrlb1bwhykrg4iyqg4whxadcs441k10xx0r75i6220mn";
  };

  # note: optional component libCGAL_ImageIO would need zlib and opengl;
  #   there are also libCGAL_Qt{3,4} omitted ATM
  buildInputs = [ boost gmp mpfr ];
  nativeBuildInputs = [ cmake ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Computational Geometry Algorithms Library";
    homepage = http://cgal.org;
    license = with licenses; [ gpl3Plus lgpl3Plus];
    platforms = platforms.all;
    maintainers = [ maintainers.raskin ];
  };
}
