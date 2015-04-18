{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "libuchardet-${version}";

  version = "0.0.1";

  src = fetchFromGitHub {
    owner  = "BYVoid";
    repo   = "uchardet";
    rev    = "69b7133995e4ee260b093323c57a7f8c6c6803b8";
    sha256 = "0yqrc9a7wxsh2fvigjppjp55v4r1q8p40yh048xsvl3kly2rkqy9";
  };

  buildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Mozilla's Universal Charset Detector C/C++ API";
    homepage    = https://www.byvoid.com/zht/project/uchardet;
    license     = licenses.mpl11;
    maintainers = with maintainers; [ cstrahan ];
  };
}
