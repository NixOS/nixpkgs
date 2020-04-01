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
  version = "4.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "f9967b4deb48e619f6c40558f69e48978779cc09c8a7fad33d536cfc41cd68f9";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    cryptography
  ];

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
