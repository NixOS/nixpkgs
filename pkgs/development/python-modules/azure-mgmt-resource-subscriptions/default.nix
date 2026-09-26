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

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-resource-subscriptions";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_resource_subscriptions";
    inherit (finalAttrs) version;
    hash = "sha256-jBJRxU70+phR/M9KrlMA9Nq9MZNXeDFSuTD9lh9NBOs=";
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
    "azure.mgmt.resource.subscriptions"
    "azure.mgmt.resource.subscriptions.models"
  ];

  meta = {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-resource-subscriptions";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-resource-subscriptions_${finalAttrs.version}/sdk/resources/azure-mgmt-resource-subscriptions/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
})
