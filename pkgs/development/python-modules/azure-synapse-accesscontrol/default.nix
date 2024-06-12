{
  lib,
  azure-common,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-synapse-accesscontrol";
  version = "0.7.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
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

  meta = with lib; {
    description = "Microsoft Azure Synapse AccessControl Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/synapse/azure-synapse-accesscontrol";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-synapse-accesscontrol_${version}/sdk/synapse/azure-synapse-accesscontrol/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
