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
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ckhhx3x0xvqqzs36d368z02fr2k23waazx0v2fjn8hqbnzilf4k";
  };

  propagatedBuildInputs = [
    azure-common
    azure-storage-common
  ] ++ lib.optional (!isPy3k) futures;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the blob service APIs";
    homepage = https://github.com/Azure/azure-storage-python/tree/master/azure-storage-blob;
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai mwilsoninsight ];
  };
}
