{stdenv, fetchFromGitHub, cmake}:

stdenv.mkDerivation rec {
  version = "1.3.0";
  pname = "nanoflann";
  
  src = fetchFromGitHub {
    owner = "jlblancoc";
    repo = "nanoflann";
    rev = "v${version}";
    sha256 = "1bwdmrz1qygp9qy2nzrp1axa1i4nvm0ljkn6mnhlcvbfsyvhzigv";
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
