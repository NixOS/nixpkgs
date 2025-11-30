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
  pname = "azure-synapse-managedprivateendpoints";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-kA6urM/9zQEBKySKfQSQCMkoB7dJ7dHJB0ypJIVUwX4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-core
    msrest
  ];

  pythonNamespaces = [ "azure.synapse" ];

  pythonImportsCheck = [ "azure.synapse.managedprivateendpoints" ];

  meta = with lib; {
    description = "Microsoft Azure Synapse Managed Private Endpoints Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/synapse/azure-synapse-managedprivateendpoints";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-synapse-managedprivateendpoints_${version}/sdk/synapse/azure-synapse-managedprivateendpoints";
    license = licenses.mit;
    maintainers = [ ];
  };
}
