{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  azure-mgmt-core,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerregistry";
  version = "15.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_containerregistry";
    inherit version;
    hash = "sha256-oxpwt7aBHTQ8JoBKFG8eTBsS9mYMbjgdLVAXsnvKtXM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.containerregistry"
  ];

  meta = {
    description = "Microsoft Azure Container Registry Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/containerregistry/azure-mgmt-containerregistry";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-containerregistry_${version}/sdk/containerregistry/azure-mgmt-containerregistry/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
