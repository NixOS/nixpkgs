{ lib
, buildPythonPackage
, fetchPypi
, azure-core
, uamqp
}:

buildPythonPackage rec {
  pname = "azure-eventhub";
  version = "5.7.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "6ac364e5f1c5b376604c3b5a25ad0be5e3a5f96368f590e05b47e6745f1006ee";
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
