{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "microsoft-security-utilities-secret-masker";
  version = "1.0.0b3";
  pyproject = true;

  src = fetchPypi {
    pname = "microsoft_security_utilities_secret_masker";
    inherit version;
    hash = "sha256-0EVIIwxno70stGCyjnH+bKwWj0jwbXapadnKR732c0M=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "microsoft_security_utilities_secret_masker"
  ];

  meta = {
    description = "A tool for detecting and masking secrets";
    homepage = "https://pypi.org/project/microsoft-security-utilities-secret-masker/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
