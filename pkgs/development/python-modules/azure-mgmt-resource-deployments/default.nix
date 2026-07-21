{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-core,
  azure-common,
  isodate,
  setuptools,
  typing-extensions,
  azure-cli,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-resource-deployments";
  version = "1.0.0b2";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_resource_deployments";
    inherit version;
    hash = "sha256-RVBRTFK4uwZH213SRLSUs0gl0cV8CRph0RZOGQQOw+I=";
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
    "azure.mgmt"
    "azure.mgmt.resource"
  ];

  pythonImportsCheck = [
    "azure.mgmt.resource.deployments"
    "azure.mgmt.resource.deployments.models"
  ];

  meta = {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-resource-deployments";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-resource-deployments_${version}/sdk/resources/azure-mgmt-resource-deployments/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
