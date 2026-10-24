{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "safe-pysha3";
  version = "1.0.7";
  pyproject = true;

  src = fetchPypi {
    pname = "safe_pysha3";
    inherit version;
    hash = "sha256-CsNAb743w8lh77RG8RferzBJQR0pim5XPMS66XMuGaE=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [ "sha3" ];

  meta = {
    changelog = "https://github.com/5afe/pysha3/releases/tag/v${version}";
    description = "SHA-3 (Keccak) for Python 3.10 - 3.15";
    homepage = "https://github.com/5afe/pysha3";
    license = lib.licenses.psfl;
    maintainers = with lib.maintainers; [ wegank ];
  };
}
