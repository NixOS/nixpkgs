{ lib, buildPythonPackage, fetchFromGitHub, cython, pexpect, python }:

buildPythonPackage rec {
  pname = "cpyparsing";
  version = "2.4.7.1.1.0";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = pname;
    rev = "v${version}"; # No tags on repo
    sha256 = "1rqj89mb4dz0xk8djh506nrlqfqqdva9qgb5llrvvwjqv3vqnrj4";
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
