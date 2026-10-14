{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-awscrt,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "botocore-stubs";
  version = "1.43.113";
  pyproject = true;

  src = fetchPypi {
    pname = "botocore_stubs";
    inherit (finalAttrs) version;
    hash = "sha256-Sd7aFm7O7mQkPMoLXcneXOAFlJ3unq1Hf43yK6+u43Q=";
  };

  build-system = [ setuptools ];

  dependencies = [
    types-awscrt
    typing-extensions
  ];

  pythonImportsCheck = [ "botocore-stubs" ];

  meta = {
    description = "Type annotations and code completion for botocore";
    homepage = "https://pypi.org/project/botocore-stubs/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
