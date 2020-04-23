{ lib
, buildPythonPackage
, fetchPypi
, python
, isPy3k
, azure-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  pname = "azure-keyvault-certificates";
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "069l6m80rq4smyqbrmjb2w18wxxg49xi2yrf1wsxpq8r0r45cksl";
  };

  propagatedBuildInputs = [
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
