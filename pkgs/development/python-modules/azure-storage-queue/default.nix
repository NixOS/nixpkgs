{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-storage-common
, msrest
}:

buildPythonPackage rec {
  pname = "azure-storage-queue";
  version = "12.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OzdEJK9y0y2v+Lr5tkYwB0w6iz/VMypFIWs7yWvHsXI=";
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
