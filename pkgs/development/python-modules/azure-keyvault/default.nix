{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, azure-keyvault-certificates
, azure-keyvault-keys
, azure-keyvault-secrets
}:

buildPythonPackage rec {
  pname = "azure-keyvault";
  version = "4.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-cxrdEIo+KatP1QGjxHclbChsNNCZazg/tqOUVGKTN2E=";
  };

  propagatedBuildInputs = [
    azure-keyvault-certificates
    azure-keyvault-keys
    azure-keyvault-secrets
  ];

  # this is just a meta package, which contains keys and secrets packages
  doCheck = false;
  doBuild = false;

  pythonImportsCheck = [
    "azure.keyvault.keys"
    "azure.keyvault.secrets"
  ];

  meta = with lib; {
    description = "This is the Microsoft Azure Key Vault Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
