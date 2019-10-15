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
  version = "1.4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ec87c7537d457ec95252e0e46477e2c1ccf33774ffefd05d8544682cb0ae401";
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
