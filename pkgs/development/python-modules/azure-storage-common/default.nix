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
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0227pnbha1npw50p3498y621la8hl272am51ggrvy3xmdxgwv423";
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
