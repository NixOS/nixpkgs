{ lib
, buildPythonPackage
, fetchPypi
, azure-core
, uamqp
}:

buildPythonPackage rec {
  pname = "azure-eventhub";
  version = "5.9.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-UJxrNR2wwWdKfDMwjm/+vFqb0rCp0QvLL6PQo6R9QtA=";
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
