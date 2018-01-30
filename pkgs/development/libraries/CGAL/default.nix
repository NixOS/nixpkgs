{ stdenv, fetchFromGitHub, cmake, boost, gmp, mpfr }:

stdenv.mkDerivation rec {
  version = "4.11";
  name = "cgal-" + version;

  src = fetchFromGitHub {
    owner = "CGAL";
    repo = "releases";
    rev = "CGAL-${version}";
    sha256 = "126r06aba5h8l73xmm5mwmxkir7sy122jn2j18cd4gz3z9p23npr";
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
