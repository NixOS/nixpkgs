{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, pexpect
, python
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cpyparsing";
  version = "2.4.7.1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cb0Lx+S9WnPa9veHJaYEU7pFCtB6pG/GKf4HK/UbmtU=";
  };

  nativeBuildInputs = [ cython ];

  checkInputs = [ pexpect ];

  checkPhase = ''
    ${python.interpreter} tests/cPyparsing_test.py
  '';

  pythonImportsCheck = [
    "cPyparsing"
  ];

  meta = with lib; {
    description = "Cython PyParsing implementation";
    homepage = "https://github.com/evhub/cpyparsing";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
