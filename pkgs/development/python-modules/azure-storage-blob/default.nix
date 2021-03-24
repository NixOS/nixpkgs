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
  version = "12.8.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "36b85a3423379d4a93f663022487cf53aa3043a355f8414321dde878c00cb577";
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
