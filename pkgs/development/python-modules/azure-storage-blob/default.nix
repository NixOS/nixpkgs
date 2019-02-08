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
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "65ebe2e54460566c2077c6b3773a2a0623eabc7b95602010cb51b84077087fda";
  };

  propagatedBuildInputs = [
    azure-common
    azure-storage-common
  ] ++ lib.optional (!isPy3k) futures;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the blob service APIs";
    homepage = https://github.com/Azure/azure-storage-python/tree/master/azure-storage-blob;
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
