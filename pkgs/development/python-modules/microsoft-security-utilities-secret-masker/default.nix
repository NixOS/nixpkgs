{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "microsoft-security-utilities-secret-masker";
  version = "1.0.0b4";
  pyproject = true;

  src = fetchPypi {
    pname = "microsoft_security_utilities_secret_masker";
    inherit version;
    hash = "sha256-owvTYawYyLUvaEQHa8JkZTNZSeqcegBNlfUZbsb97z4=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [
    "microsoft_security_utilities_secret_masker"
  ];

  meta = {
    description = "Tool for detecting and masking secrets";
    homepage = "https://pypi.org/project/microsoft-security-utilities-secret-masker/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
