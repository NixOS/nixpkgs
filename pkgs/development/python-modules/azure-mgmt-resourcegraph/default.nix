{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-core,
  msrest,
  setuptools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-resourcegraph";
  version = "8.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_resourcegraph";
    inherit (finalAttrs) version;
    hash = "sha256-VaIdZtprKKCA2QPsoZLQL8HP0HdeE5sw1EEXykumrR8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-mgmt-core
    msrest
    typing-extensions
  ];

  # Tests are only available in mono repo
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.resourcegraph" ];

  meta = {
    description = "Microsoft Azure Resource Graph Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-resourcegraph";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-resourcegraph_${finalAttrs.version}/sdk/resources/azure-mgmt-resourcegraph/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bryanhonof ];
  };
})
