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
  pname = "azure-mgmt-resource-deploymentstacks";
  version = "1.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_resource_deploymentstacks";
    inherit version;
    hash = "sha256-gI3N1xc36cpOfLhLxip079VFe2ptsOVgfNNshv1YLcc=";
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

  meta = {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-resource-deploymentstacks";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-resource-deploymentstacks_${version}/sdk/resources/azure-mgmt-resource-deploymentstacks/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
