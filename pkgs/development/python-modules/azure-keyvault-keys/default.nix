{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, azure-common
, azure-core
, cryptography
, msrest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "azure-keyvault-keys";
  version = "4.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-2ojnH+ySoU+1jOyIaKv366BAGI3Nzjac4QUK3RllhvY=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    cryptography
  ];

  checkInputs = [
    aiohttp
    pytestCheckHook
  ];

  pythonNamespaces = [
    "azure.keyvault"
  ];

  # requires relative paths to utilities in the mono-repo
  doCheck = false;

  pythonImportsCheck = [
    "azure"
    "azure.core"
    "azure.common"
    "azure.keyvault"
    "azure.keyvault.keys"
  ];

  meta = with lib; {
    description = "Microsoft Azure Key Vault Keys Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
