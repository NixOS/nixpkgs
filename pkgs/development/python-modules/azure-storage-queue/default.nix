{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-storage-common
}:

buildPythonPackage rec {
  pname = "azure-storage-queue";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14e82d3691f1bbd23f2aff143a6c17af3c297164f6e597d223b65a67051ba278";
  };

  propagatedBuildInputs = [
    azure-common
    azure-storage-common
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
