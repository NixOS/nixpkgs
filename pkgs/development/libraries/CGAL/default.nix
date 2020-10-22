{ stdenv
, fetchFromGitHub
, cmake
, boost
, gmp
, mpfr
}:

stdenv.mkDerivation rec {
  pname = "cgal";
  version = "5.1";

  src = fetchFromGitHub {
    owner = "CGAL";
    repo = "releases";
    rev = "CGAL-${version}";
    sha256 = "0rcv86hn5aqna7vr9nfk4np778qjr7l3742v58w6qw0z4y6l1km0";
  };

  # note: optional component libCGAL_ImageIO would need zlib and opengl;
  #   there are also libCGAL_Qt{3,4} omitted ATM
  buildInputs = [ boost gmp mpfr ];
  nativeBuildInputs = [ cmake ];

  patches = [ ./cgal_path.patch ];

  doCheck = false;

  meta = with stdenv.lib; {
    description = "Computational Geometry Algorithms Library";
    homepage = "http://cgal.org";
    license = with licenses; [ gpl3Plus lgpl3Plus];
    platforms = platforms.all;
    maintainers = [ maintainers.raskin ];
  };
}
