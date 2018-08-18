{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "qhull-2016.1";

  src = fetchFromGitHub {
    owner = "qhull";
    repo = "qhull";
    rev = "5bbc75608c817b50383a0c24c3977cc09d0bbfde";
    sha256 = "0wrgqc2mih7h8fs9v5jcn9dr56afqi9bgh2w9dcvzvzvxizr9kjj";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = http://www.qhull.org/;
    description = "Compute the convex hull, Delaunay triangulation, Voronoi diagram and more";
    license = licenses.free;
    platforms = platforms.unix;
    maintainers = with maintainers; [ orivej ];
  };
}
