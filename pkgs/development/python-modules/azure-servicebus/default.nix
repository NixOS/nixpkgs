{
  lib,
  azure-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  typing-extensions,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-servicebus";
  version = "7.12.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_servicebus";
    inherit version;
    hash = "sha256-PwdZcxrSIRxo60sh5byimCf31v8Ccr3H7vEDwcE/gyI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-core
    isodate
    typing-extensions
  ];

  # Tests require dev-tools
  doCheck = false;

  pythonImportsCheck = [ "azure.servicebus" ];

  meta = with lib; {
    description = "Microsoft Azure Service Bus Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/servicebus/azure-servicebus";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-servicebus_${version}/sdk/servicebus/azure-servicebus/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
