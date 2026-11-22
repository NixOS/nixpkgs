{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-eventhub";
  version = "12.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_eventhub";
    inherit version;
    hash = "sha256-hrHlqmTquqa3imeceRHxYtXcFjPzacceD2Qv+4iboZ8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # has no tests
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure EventHub Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/eventhub/azure-mgmt-eventhub";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-eventhub_${version}/sdk/eventhub/azure-mgmt-eventhub/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
