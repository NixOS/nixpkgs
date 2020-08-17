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
  version = "4.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "5e33881f3a9b3080c815fe6a7200c0c8670ec506eff45955432ddb84f3076902";
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
