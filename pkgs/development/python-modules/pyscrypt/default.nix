{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
}:

buildPythonPackage rec {
  pname = "pyscrypt";
  version = "1.6.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uv3RlfEPfHOV8BM7rQl0amjg5rZtogLJvbax60q7pek=";
  };

  checkPhase = ''
    ${python.interpreter} tests/run-tests-hash.py
  '';

  meta = with lib; {
    homepage = "https://github.com/ricmoo/pyscrypt/";
    description = "Pure-Python implementation of Scrypt PBKDF and scrypt file format library";
    license = licenses.mit;
    maintainers = with maintainers; [ valodim ];
  };
}
