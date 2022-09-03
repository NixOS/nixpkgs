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
  version = "5.10.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "8c83fbe96a420813599a9a3c66adc315b7208f56d5a50a20aa04a8aa7062b074";
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
