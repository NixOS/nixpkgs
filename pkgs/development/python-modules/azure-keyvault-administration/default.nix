{
  lib,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-keyvault-administration";
  version = "4.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ems2y59UTzV1D/L6lMg7l7PvIMH+G0JOpoAY7ucD8d8=";
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

  meta = with lib; {
    description = "Microsoft Azure Key Vault Administration Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/keyvault/azure-keyvault-administration";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-keyvault-administration_${version}/sdk/keyvault/azure-keyvault-administration/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
