{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
}:

buildPythonPackage rec {
  version =  "0.2.0";
  src = fetchFromGitHub {
    owner = "plottertools";
    repo = "pnoise";
    rev = version;
    sha256 = "sha256-JwWzLvgCNSLRs/ToZNFH6fN6VLEsQTmsgxxkugwjA9k=";
  };

  pname = "pnoise";

  propagatedBuildInputs = [ numpy ];

  meta = with lib; {
    description = "pnoise is a pure-Python, Numpy-based, vectorized port of Processing's noise() function.";
    homepage = "https://github.com/plottertools/pnoise/";
    platforms = platforms.unix;
    maintainers = with maintainers; [rrix];
    license = with licenses; [ lgpl21 ];
  };
}
