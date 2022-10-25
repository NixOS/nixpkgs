{ lib, buildPythonPackage, fetchFromGitHub, cython, pexpect, python }:

buildPythonPackage rec {
  pname = "cpyparsing";
  version = "2.4.7.1.2.0";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-cb0Lx+S9WnPa9veHJaYEU7pFCtB6pG/GKf4HK/UbmtU=";
  };

  nativeBuildInputs = [ cython ];

  checkInputs = [ pexpect ];

  checkPhase = "${python.interpreter} tests/cPyparsing_test.py";

  meta = with lib; {
    homepage = "https://github.com/evhub/cpyparsing";
    description = "Cython PyParsing implementation";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
