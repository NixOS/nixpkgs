{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  pexpect,
  python,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cpyparsing";
  version = "2.4.7.2.4.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bmoHri14gWvTekgoScA1v0qVhre+08aRwx0V6AvfPdQ=";
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

  meta = {
    description = "Cython PyParsing implementation";
    homepage = "https://github.com/evhub/cpyparsing";
    changelog = "https://github.com/evhub/cpyparsing/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fabianhjr ];
  };
}
