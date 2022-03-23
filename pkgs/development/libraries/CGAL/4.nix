{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, boost, gmp, mpfr }:

stdenv.mkDerivation rec {
  version = "4.14.2";
  pname = "cgal";

  src = fetchFromGitHub {
    owner = "CGAL";
    repo = "releases";
    rev = "CGAL-${version}";
    sha256 = "1p1xyws2s9h2c8hlkz1af4ix48qma160av24by6lcm8al1g44pca";
  };

  patches = [

    # Pull upstream fix for c++17 (gcc-12):
    #  https://github.com/CGAL/cgal/pull/6109
    (fetchpatch {
      name = "gcc-12-prereq.patch";
      url = "https://github.com/CGAL/cgal/commit/4581f1b7a8e97d1a136830e64b77cdae3546c4bf.patch";
      sha256 = "1gzrvbrwxylv80v0m3j2s1znlysmr69lp3ggagnh38lp6423i6pq";
      # Upstream slightly reordered directory structure since.
      stripLen = 1;
      # Fill patch does not apply: touches too many parts of the source.
      includes = [ "include/CGAL/CORE/BigFloatRep.h" ];
    })
    (fetchpatch {
      name = "gcc-12.patch";
      url = "https://github.com/CGAL/cgal/commit/6680a6e6f994b2c5b9f068eb3014d12ee1134d53.patch";
      sha256 = "1c0h1lh8zng60yx78qc8wx714b517mil8mac87v6xr21q0b11wk7";
      # Upstream slightly reordered directory structure since.
      stripLen = 1;
    })
  ];

  # note: optional component libCGAL_ImageIO would need zlib and opengl;
  #   there are also libCGAL_Qt{3,4} omitted ATM
  buildInputs = [ boost gmp mpfr ];
  nativeBuildInputs = [ cmake ];

  doCheck = false;

  meta = with lib; {
    description = "Computational Geometry Algorithms Library";
    homepage = "http://cgal.org";
    license = with licenses; [ gpl3Plus lgpl3Plus];
    platforms = platforms.all;
    maintainers = [ maintainers.raskin ];
  };
}
