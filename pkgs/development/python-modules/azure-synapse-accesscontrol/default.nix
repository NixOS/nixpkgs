{
  lib,
  azure-common,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-synapse-accesscontrol";
  version = "0.7.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-VlqiYzbVYMAod16K5Q0GkapwielhcOeDQjcbdz2jE3w=";
    extension = "zip";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-core
    msrest
  ];

  # zero tests run
  doCheck = false;

  pythonImportsCheck = [ "azure.synapse.accesscontrol" ];

  meta = {
    description = "Microsoft Azure Synapse AccessControl Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/synapse/azure-synapse-accesscontrol";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-synapse-accesscontrol_${finalAttrs.version}/sdk/synapse/azure-synapse-accesscontrol/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
