{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zinnia";
  version = "2016-08-28";

  src = fetchFromGitHub {
    owner = "taku910";
    repo = "zinnia";
    rev = "fd74d8c8680bb3df8692279151ea6339ab68e32b";
    sha256 = "1izjy5qw6swg0rs2ym2i72zndb90mwrfbd1iv8xbpwckbm4899lg";
  };

  sourceRoot = "${finalAttrs.src.name}/zinnia";

  patches = [
    # Fixes the following error on darwin:
    # svm.cpp:50:10: error: no member named 'random_shuffle' in namespace 'std'
    ./remove-random-shuffle-usage.patch
  ];

  meta = {
    description = "Online hand recognition system with machine learning";
    homepage = "http://taku910.github.io/zinnia/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
