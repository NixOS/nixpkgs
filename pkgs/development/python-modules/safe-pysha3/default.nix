{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, python
}:

buildPythonPackage rec {
  pname = "safe-pysha3";
  version = "1.0.3";
  format = "setuptools";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Kd+lb9t5ney50BvdfbwPKAb0Ro0sKW+DtuN9hlMZF8I=";
  };

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} tests.py

    runHook postCheck
  '';

  pythonImportsCheck = [
    "sha3"
  ];

  meta = {
    changelog = "https://github.com/5afe/pysha3/releases/tag/v${version}";
    description = "SHA-3 (Keccak) for Python 3.9 - 3.11";
    homepage = "https://github.com/5afe/pysha3";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
