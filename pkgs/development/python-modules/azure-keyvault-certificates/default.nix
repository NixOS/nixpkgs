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
  version = "4.3.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "4e0a9bae9fd4c222617fbce6b31f97e2e0622774479de3c387239cbfbb828d87";
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
