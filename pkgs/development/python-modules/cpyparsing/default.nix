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
  version = "2.4.7.1.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-HJ0I5DKZ2WV+1pXZCvJHA7Wih3Gkn7vL/ojXnTssKxw=";
  };

  nativeBuildInputs = [
    cython
  ];

  nativeCheckInputs = [
    pexpect
  ];

  checkPhase = ''
    ${python.interpreter} tests/cPyparsing_test.py
  '';

  pythonImportsCheck = [
    "cPyparsing"
  ];

  meta = with lib; {
    description = "Cython PyParsing implementation";
    homepage = "https://github.com/evhub/cpyparsing";
    changelog = "https://github.com/evhub/cpyparsing/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
