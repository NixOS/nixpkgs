{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-core
, msrest
, msrestazure
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-keyvault-certificates";
  version = "4.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-4eIIF90ZSajuzlGFrUOQacWR1AdmSP2cY8EeM5McGZA=";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    msrestazure
  ];

  pythonNamespaces = [
    "azure.keyvault"
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.keyvault.certificates"
  ];

  meta = with lib; {
    description = "Microsoft Azure Key Vault Certificates Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
