{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  pexpect,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cpyparsing";
  version = "2.4.7.2.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "evhub";
    repo = "cpyparsing";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ob3aSxJXM/J1KQ2dwxew9fH3g2WVU2KI6lynDz31r+Y=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  nativeCheckInputs = [ pexpect ];

  checkPhase = ''
    ${python.interpreter} tests/cPyparsing_test.py
  '';

  pythonImportsCheck = [ "cPyparsing" ];

  meta = with lib; {
    description = "Cython PyParsing implementation";
    homepage = "https://github.com/evhub/cpyparsing";
    changelog = "https://github.com/evhub/cpyparsing/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fabianhjr ];
  };
}
