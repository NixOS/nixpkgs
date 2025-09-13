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
  pname = "azure-mgmt-resource-deploymentstacks";
  version = "1.0.0b1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "azure_mgmt_resource_deploymentstacks";
    inherit version;
    hash = "sha256-Sbh25FwPW6uI7EfXxW6Ps0+9/P5bgxo6KiHoF/PZcy4=";
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
    "azure.mgmt.resource.deploymentstacks"
  ];

  pythonImportsCheck = [
    "azure.mgmt.resource.deploymentstacks"
  ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-resource-deploymentstacks";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-resource-deploymentstacks_${version}/sdk/resources/azure-mgmt-resource-deploymentstacks/CHANGELOG.md";
    license = licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
