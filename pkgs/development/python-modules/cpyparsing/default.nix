{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  pexpect,
  python,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cpyparsing";
  version = "2.4.7.2.4.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7j0vJicSrSUqZAExaH0bJZhRJ6XZui4SAPMBcWXy7n0=";
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
