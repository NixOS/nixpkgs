{ lib, buildPythonPackage, isPy27, fetchPypi
, azure-keyvault-certificates
, azure-keyvault-keys
, azure-keyvault-secrets
}:

buildPythonPackage rec {
  pname = "azure-keyvault";
  version = "4.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "69002a546921a8290eb54d9a3805cfc515c321bc1d4c0bfcfb463620245eca40";
  };

  propagatedBuildInputs = [
    azure-keyvault-certificates
    azure-keyvault-keys
    azure-keyvault-secrets
  ];

  # this is just a meta package, which contains keys and secrets
  doCheck = false;

  pythonNamespaces = [ "azure" ];

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
