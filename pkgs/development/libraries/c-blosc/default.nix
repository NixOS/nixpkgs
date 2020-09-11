{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "c-blosc";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "Blosc";
    repo = "c-blosc";
    rev = "v${version}";
    sha256 = "1rhv9na9cdp2j81a981s2y69c7m9apdiylf9j51dij0lm1m0ljdr";
  };

  buildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A blocking, shuffling and loss-less compression library";
    homepage = "https://www.blosc.org";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
