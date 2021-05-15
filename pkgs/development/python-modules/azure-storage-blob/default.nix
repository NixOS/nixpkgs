{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-core
, azure-storage-common
, msrest
, isPy3k
, futures ? null
}:

buildPythonPackage rec {
  pname = "azure-storage-blob";
  version = "12.8.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "eb37b50ddfb6e558b29f6c8c03b0666514e55d6170bf4624e7261a3af93c6401";
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
