{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, azure-common
, azure-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-keyvault-certificates";
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "ea651883ad00d0a9a25b38e51feff7111f6c7099c6fb2597598da5bb21d3451c";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
    msrestazure
  ];

  pythonNamespaces = [ "azure.keyvault" ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.keyvault.certificates" ];

  meta = with lib; {
    description = "Microsoft Azure Key Vault Certificates Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
