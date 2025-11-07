{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  wheel,
  azure-core,
  isodate,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-keyvault-securitydomain";
  version = "1.0.0b1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_keyvault_securitydomain";
    inherit version;
    hash = "sha256-MpGhked4qUfkso7QEyeJKpOu3PjgoN1nTPEWyxEEN3Y=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    azure-core
    isodate
    typing-extensions
  ];

  pythonImportsCheck = [
    "azure.keyvault.securitydomain"
  ];

  meta = {
    description = "Microsoft Corporation Azure Keyvault Securitydomain Client Library for Python";
    homepage = "https://pypi.org/project/azure-keyvault-securitydomain/1.0.0b1/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ katexochen ];
  };
}
