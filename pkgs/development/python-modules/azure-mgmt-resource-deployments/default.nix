{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-core,
  azure-common,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
  azure-cli,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-resource-deployments";
  version = "1.0.0b1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "azure_mgmt_resource_deployments";
    inherit version;
    hash = "sha256-c1m0JliCbn5/8T5tuwxJDpX8yV28oiTSuFz3GtdTXx0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [
    "azure.mgmt.resource.deployments"
  ];

  pythonImportsCheck = [
    "azure.mgmt.resource.deployments"
    "azure.mgmt.resource.deployments.models"
  ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-resource-deployments";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-resource-deployments_${version}/sdk/resources/azure-mgmt-resource-deployments/CHANGELOG.md";
    license = licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
