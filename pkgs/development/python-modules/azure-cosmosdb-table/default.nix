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
    sha256 = "5f061d2ab8dcf2f0b4e965d5976e7b7aeb1247ea896911f0e1d29092aaaa29c7";
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
