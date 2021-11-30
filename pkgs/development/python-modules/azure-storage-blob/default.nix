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
  version = "12.9.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "cff66a115c73c90e496c8c8b3026898a3ce64100840276e9245434e28a864225";
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
