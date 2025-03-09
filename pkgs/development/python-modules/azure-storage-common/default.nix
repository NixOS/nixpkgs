{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-common,
  cryptography,
  python-dateutil,
  requests,
  isPy3k,
  azure-storage-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-storage-common";
  version = "2.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ccedef5c67227bc4d6670ffd37cec18fb529a1b7c3a5e53e4096eb0cf23dc73f";
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
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
