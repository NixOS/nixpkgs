{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-storage-common
, msrest
}:

buildPythonPackage rec {
  pname = "azure-storage-queue";
  version = "12.6.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GaAfHYYLXll4nhcnzmrsTwkDrFYwelZMT6d3+zi2tQ0=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-storage-common
    msrest
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the queue service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
