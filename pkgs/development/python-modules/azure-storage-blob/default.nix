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
  version = "1.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f187a878e7a191f4e098159904f72b4146cf70e1aabaf6484ab4ba72fc6f252c";
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
    maintainers = with maintainers; [ cmcdragonkai mwilsoninsight ];
  };
}
