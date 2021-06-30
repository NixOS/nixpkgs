{ lib
, buildPythonPackage
, fetchPypi
, azure-core
, uamqp
}:

buildPythonPackage rec {
  pname = "azure-eventhub";
  version = "5.5.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "7b757b4910ac74902564b38089b9861c1bc51ff15bd49ff056888f939f7c4c49";
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
