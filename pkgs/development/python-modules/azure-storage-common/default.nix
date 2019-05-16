{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, cryptography
, python-dateutil
, requests
, isPy3k
, azure-storage-nspkg
}:

buildPythonPackage rec {
  pname = "azure-storage-common";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7ab607f9b8fd27b817482194b1e7d43484c65dcf2605aae21ad8706c6891934d";
  };

  propagatedBuildInputs = [
    azure-common
    cryptography
    python-dateutil
    requests
  ] ++ lib.optional (!isPy3k) azure-storage-nspkg;

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "Client library for Microsoft Azure Storage services containing common code shared by blob, file and queue";
    homepage = https://github.com/Azure/azure-storage-python/tree/master/azure-storage-common;
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
