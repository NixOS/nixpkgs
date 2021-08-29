{ lib, buildPythonPackage, fetchFromGitHub, cython, python }:

buildPythonPackage rec {
  pname = "cpyparsing";
  version = "2.4.5.0.1.1";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = pname;
    rev = "aa8ee45daec5c55328446bad7202ab8f799ab0ce"; # No tags on repo
    sha256 = "1mxa5q41cb0k4lkibs0d4lzh1w6kmhhdrsm0w0r1m3s80m05ffmw";
  };

  nativeBuildInputs = [ cython ];

  checkPhase = "${python.interpreter} tests/cPyparsing_test.py";

  meta = with lib; {
    homepage = "https://github.com/evhub/cpyparsing";
    description = "Cython PyParsing implementation";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
