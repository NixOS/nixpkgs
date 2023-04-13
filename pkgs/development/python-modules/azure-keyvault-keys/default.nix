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
  version = "4.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-bAuy94MgKjSj5ex0hm5iEuWRrHEk8DuWadGwm2giS8Q=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    cryptography
  ];

  nativeCheckInputs = [
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
