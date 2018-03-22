{stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  version = "1.2.3";
  name = "nanoflann-${version}";
  
  src = fetchFromGitHub {
    owner = "jlblancoc";
    repo = "nanoflann";
    rev = "v${version}";
    sha256 = "1jrh73kjvdv7s7zc1sc3z254i17lpvn77b19wx32nvzsfxs4g44i";
  };

  buildInputs = [ cmake ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    homepage = https://github.com/jlblancoc/nanoflann;
    license = stdenv.lib.licenses.bsd3;
    description = "Header only C++ library for approximate nearest neighbor search";
    platforms = stdenv.lib.platforms.unix;
  };
}
