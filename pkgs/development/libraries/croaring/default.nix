{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "croaring";
  version = "0.2.61";

  src = fetchFromGitHub {
    owner = "RoaringBitmap";
    repo = "CRoaring";
    rev = "v${version}";
    sha256 = "14y8iwv6b6gg7hgs00yqg8rwx4vwbb1zs2s99lxa51zx9vp1alcn";
  };

  patches = fetchpatch {
    url = "https://github.com/RoaringBitmap/CRoaring/commit/8d8c60736f506b2b8f1c365148a8a541b26a55f2.patch";
    sha256 = "1y2mbn4i8lj3lkn5s8zziyr9pl1fq9hndzz9c01dkv3s8sn7f55s";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Compressed bitset library for C and C++";
    homepage = "http://roaringbitmap.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ orivej ];
    platforms = platforms.all;
  };
}
