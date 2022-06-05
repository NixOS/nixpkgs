{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-keyvault-administration";
  version = "4.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "sha256-V8tppRExyvSt41nN+j2QoxGSund6RKvE4g5p6AWZ3qI=";
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
