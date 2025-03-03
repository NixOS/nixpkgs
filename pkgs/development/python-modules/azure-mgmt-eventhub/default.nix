{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-eventhub";
  version = "11.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "azure_mgmt_eventhub";
    inherit version;
    hash = "sha256-McR/GPc9LYM0XN5ZCVaOKIWMJUijWxDiMZS0dnqc5+M=";
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

  meta = with lib; {
    description = "This is the Microsoft Azure EventHub Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/eventhub/azure-mgmt-eventhub";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-eventhub_${version}/sdk/eventhub/azure-mgmt-eventhub/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
