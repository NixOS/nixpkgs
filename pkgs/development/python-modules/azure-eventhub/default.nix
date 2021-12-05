{ lib, buildPythonPackage, fetchPypi, azure-core, uamqp }:

buildPythonPackage rec {
  pname = "azure-eventhub";
  version = "5.6.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-ssjTesjPFITaB5Uy061podqL14ojeCIVm3LWsF3kY40=";
  };

  propagatedBuildInputs = [ azure-core uamqp ];

  # too complicated to set up
  doCheck = false;

  pythonImportsCheck = [ "azure.eventhub" "azure.eventhub.aio" ];

  meta = with lib; {
    description = "Microsoft Azure Event Hubs Client Library for Python";
    homepage =
      "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/eventhub/azure-eventhub";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
