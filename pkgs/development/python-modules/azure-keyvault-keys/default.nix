{ lib, buildPythonPackage, isPy27, fetchPypi
, aiohttp
, azure-common
, azure-core
, azure-nspkg
, cryptography
, msrest
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "azure-keyvault-keys";
  version = "4.3.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "fbf67bca913ebf68b9075ee9d2e2b899dc3c7892cc40abfe1b08220a382f6ed9";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    cryptography
  ];

  pythonNamespaces = [ "azure.keyvault" ];

  # requires relative paths to utilities in the mono-repo
  doCheck = false;
  checkInputs = [ aiohttp pytestCheckHook ];

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
