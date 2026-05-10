{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-deploymentmanager";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m623aGFyCRScM+aMouWcNbHT0RQn4paYcvLiNuFO7ng=";
    extension = "zip";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    msrest
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.deploymentmanager"
  ];

  meta = {
    description = "Microsoft Azure Deployment Manager Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/deploymentmanager/azure-mgmt-deploymentmanager";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-deploymentmanager_${version}/sdk/deploymentmanager/azure-mgmt-deploymentmanager/setup.py";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
