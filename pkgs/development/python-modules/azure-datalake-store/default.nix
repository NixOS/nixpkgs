{
  lib,
  adal,
  azure-common,
  buildPythonPackage,
  fetchPypi,
  msal,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-datalake-store";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_datalake_store";
    inherit (finalAttrs) version;
    hash = "sha256-U2TURFqrFUocfLECFWKcPORs5ceqrxYHGJDAP65ToDU=";
  };

  build-system = [ setuptools ];

  dependencies = [
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
})
