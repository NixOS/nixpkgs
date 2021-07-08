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
  version = "4.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "7792ad0d5e63ad9eafa68bdce5de91b3ffcc7ca7a6afdc576785e6a2793caed0";
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
