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
  version = "5.11.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-aLiaNRUEDxF2+bSWxMdtOBwQd3mu13V8u7mj2r4wqCM=";
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
