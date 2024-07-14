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
    hash = "sha256-zO3vXGcie8TWZw/9N87Bj7UpobfDpeU+QJbrDPI9xz8=";
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
