{ lib
, azure-common
, azure-core
, buildPythonPackage
, fetchPypi
, isodate
, msrest
, pythonOlder
, typing-extensions
, uamqp
}:

buildPythonPackage rec {
  pname = "azure-servicebus";
  version = "7.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Xr5KU7/BAw9AH2lOrB7NJ8FB2ATl5vzyNXQrLWKUbks=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    isodate
    msrest
    typing-extensions
    uamqp
  ];

  # Tests require dev-tools
  doCheck = false;

  pythonImportsCheck = [
    "azure.servicebus"
  ];

  meta = with lib; {
    description = "Microsoft Azure Service Bus Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-servicebus_${version}/sdk/servicebus/azure-servicebus/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
