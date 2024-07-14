{
  lib,
  buildPythonPackage,
  fetchPypi,
  cryptography,
  azure-common,
  azure-storage-common,
  azure-cosmosdb-nspkg,
  futures ? null,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "azure-cosmosdb-table";
  version = "1.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XwYdKrjc8vC06WXVl257eusSR+qJaRHw4dKQkqqqKcc=";
  };

  propagatedBuildInputs = [
    cryptography
    azure-common
    azure-storage-common
    azure-cosmosdb-nspkg
  ] ++ lib.optionals (!isPy3k) [ futures ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Log Analytics Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
