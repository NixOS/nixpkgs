{ lib, buildPythonPackage, isPy27, fetchPypi
, azure-keyvault-keys
, azure-keyvault-secrets
}:

buildPythonPackage rec {
  pname = "azure-keyvault";
  version = "4.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "e85f5bd6cb4f10b3248b99bbf02e3acc6371d366846897027d4153f18025a2d7";
  };

  propagatedBuildInputs = [
    azure-keyvault-keys
    azure-keyvault-secrets
  ];

  # this is just a meta package, which contains keys and secrets
  doCheck = false;

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
