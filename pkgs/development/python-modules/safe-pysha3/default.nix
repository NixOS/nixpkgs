{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "safe-pysha3";
  version = "1.0.5";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "safe_pysha3";
    inherit version;
    hash = "sha256-iM6q1q9La97NL1SzGtDl5eIQ1PXsq7G9H9NTmtYbe/E=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "sha3" ];

  meta = {
    changelog = "https://github.com/5afe/pysha3/releases/tag/v${version}";
    description = "SHA-3 (Keccak) for Python 3.9 - 3.13";
    homepage = "https://github.com/5afe/pysha3";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
