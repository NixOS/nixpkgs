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
  pname = "azure-mgmt-resource-deployments";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_resource_deployments";
    inherit (finalAttrs) version;
    hash = "sha256-uA8p9i4Ot9l642mp/Tz7ReCp12JmzctiwHkoDXlR0ss=";
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
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-resource-deployments_${finalAttrs.version}/sdk/resources/azure-mgmt-resource-deployments/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
})
