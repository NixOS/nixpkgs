{
  lib,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-keyvault-administration";
  version = "4.8.0b2";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_keyvault_administration";
    inherit version;
    hash = "sha256-vpR+m+p8EnB8m5Xj0X2Ky/hnJ7bo5Pd85pj//qhGZ1g=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    azure-core
    typing-extensions
    isodate
  ];

  # Tests require checkout from mono-repo
  doCheck = false;

  pythonNamespaces = [ "azure.keyvault" ];

  pythonImportsCheck = [ "azure.keyvault.administration" ];

  meta = {
    description = "Microsoft Azure Key Vault Administration Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/keyvault/azure-keyvault-administration";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-keyvault-administration_${version}/sdk/keyvault/azure-keyvault-administration/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
