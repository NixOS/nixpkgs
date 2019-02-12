{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-storage-common
}:

buildPythonPackage rec {
  pname = "azure-storage-queue";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0bafe9e61c0ce7b3f3ecadea21e931dab3248bd4989dc327a8666c5deae7f7ed";
  };

  propagatedBuildInputs = [
    azure-common
    azure-storage-common
  ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the queue service APIs";
    homepage = https://github.com/Azure/azure-storage-python/tree/master/azure-storage-queue;
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
