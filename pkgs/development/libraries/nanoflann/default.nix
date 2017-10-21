{stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  version = "1.1.9";
  name = "nanoflann-${version}";
  
  src = fetchFromGitHub {
    owner = "jlblancoc";
    repo = "nanoflann";
    rev = "v${version}";
    sha256 = "1q588cf2aark45bp4ciqjiz3dkdv8dcijkhm1ybzs8qjdzz9fimn";
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
