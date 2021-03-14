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
  version = "12.7.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "c6249f211684929ea6c9d34b5151b06d039775344f0d48fcf479736ed4c11b9e";
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
