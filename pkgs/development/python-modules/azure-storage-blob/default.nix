{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-core
, azure-storage-common
, msrest
, isPy3k
, futures
}:

buildPythonPackage rec {
  pname = "azure-storage-blob";
  version = "12.6.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "dc7832d48ae3f5b31a0b24191084ce6ef7d8dfbf73e553dfe34eaddcb6813be3";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    azure-storage-common
    msrest
  ] ++ lib.optional (!isPy3k) futures;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing the blob service APIs";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai maxwilson ];
  };
}
