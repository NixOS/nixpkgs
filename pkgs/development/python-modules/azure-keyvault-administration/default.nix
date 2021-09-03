{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-keyvault-administration";
  version = "4.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "b05a0372f35921cedb7a231426077745eee9a65881088de6d4d8b73d9709a6cb";
  };

  propagatedBuildInputs = [
    azure-common
    azure-core
    msrest
  ];

  # no tests in pypi tarball
  doCheck = false;

  pythonNamespaces = [ "azure.keyvault" ];

  pythonImportsCheck = [ "azure.keyvault.administration" ];

  meta = with lib; {
    description = "Microsoft Azure Key Vault Administration Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/master/sdk/keyvault/azure-keyvault-administration";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
