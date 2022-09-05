{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-keyvault-secrets";
  version = "4.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-IfzSrUti4E4QZzE8dAqHnIRf4CllWzinZF2MI5XQOrI=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  pythonNamespaces = [
    "azure.keyvault"
  ];

  # requires checkout from mono-repo
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Key Vault Secrets Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
