{ lib, buildPythonPackage, fetchFromGitHub, cython, pexpect, python }:

buildPythonPackage rec {
  pname = "cpyparsing";
  version = "2.4.5.0.1.2";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = pname;
    rev = "38f2b323b99cee9a080106ae9951ffc5752599f0"; # No tags on repo
    sha256 = "0wrm6vzwp968z7s0qhr23v39ivyxzvav3mv9i2n0iv9zl041kypv";
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
