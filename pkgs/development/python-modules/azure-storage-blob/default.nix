{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-storage-common
, isPy3k
, futures
}:

buildPythonPackage rec {
  pname = "azure-storage-blob";
  version = "2.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b90323aad60f207f9f90a0c4cf94c10acc313c20b39403398dfba51f25f7b454";
  };

  propagatedBuildInputs = [
    azure-common
    azure-storage-common
  ] ++ lib.optional (!isPy3k) futures;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the blob service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai mwilsoninsight ];
  };
}
