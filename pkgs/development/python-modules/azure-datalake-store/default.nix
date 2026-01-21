{
  lib,
  adal,
  azure-common,
  buildPythonPackage,
  fetchPypi,
  msal,
  requests,
}:

buildPythonPackage rec {
  pname = "azure-datalake-store";
  version = "1.0.1";
  format = "setuptools";

  src = fetchPypi {
    pname = "azure_datalake_store";
    inherit version;
    hash = "sha256-U2TURFqrFUocfLECFWKcPORs5ceqrxYHGJDAP65ToDU=";
  };

  propagatedBuildInputs = [
    adal
    azure-common
    msal
    requests
  ];

  # has no tests
  doCheck = false;

  meta = {
    description = "This project is the Python filesystem library for Azure Data Lake Store";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
