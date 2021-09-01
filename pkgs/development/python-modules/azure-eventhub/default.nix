{ lib
, buildPythonPackage
, fetchPypi
, azure-core
, uamqp
}:

buildPythonPackage rec {
  pname = "azure-eventhub";
  version = "5.6.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "aa6d9e3e9b8b1a5ad211a828de867b85910720722577a4d51cd5aa6889d1d9e9";
  };

  propagatedBuildInputs = [
    azure-core
    uamqp
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
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
