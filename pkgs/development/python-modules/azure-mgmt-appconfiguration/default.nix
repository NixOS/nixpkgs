{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "azure-mgmt-appconfiguration";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6s3KfWOlzkoq7uxuDbFMYmW22rOYHtgQgYQ6RMFQiQ8=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
    msrestazure
  ];

  # no tests included
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.common" "azure.mgmt.appconfiguration" ];

  meta = with lib; {
    description = "Microsoft Azure App Configuration Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
