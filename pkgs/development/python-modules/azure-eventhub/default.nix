{ lib
, buildPythonPackage
, fetchPypi
, azure-core
, uamqp
, pythonOlder
, typing-extensions
}:

buildPythonPackage rec {
  pname = "azure-eventhub";
  version = "5.11.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-/QVHPlElUNT7whLdMe1k8wYXePg+tQRBmXmZJM1w6fU=";
  };

  propagatedBuildInputs = [
    azure-core
    uamqp
    typing-extensions
  ];

  # too complicated to set up
  doCheck = false;

  pythonImportsCheck = [
    "azure.eventhub"
    "azure.eventhub.aio"
  ];

  meta = with lib; {
    description = "Microsoft Azure Event Hubs Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/eventhub/azure-eventhub";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-eventhub_${version}/sdk/eventhub/azure-eventhub/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
