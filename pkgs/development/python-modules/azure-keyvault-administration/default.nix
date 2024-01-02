{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, azure-common
, azure-core
, msrest
, six
}:

buildPythonPackage rec {
  pname = "azure-keyvault-administration";
  version = "4.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-PuKjui0OP0ODNErjbjJ90hOgee97JDrVT2sh+MufxWY=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    six
  ];

  # no tests in pypi tarball
  doCheck = false;

  pythonNamespaces = [
    "azure.keyvault"
  ];

  pythonImportsCheck = [
    "azure.keyvault.administration"
  ];

  meta = with lib; {
    description = "Microsoft Azure Key Vault Administration Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/keyvault/azure-keyvault-administration";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
