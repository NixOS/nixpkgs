{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.5.0";
  pname = "azure-mgmt-security";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c0d232cdb5ad74f4590db2e44df74c0872fcb9fded7f03c7b57188a63b54ecfa";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.security" ];

  meta = with lib; {
    description = "Microsoft Azure Security Center Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
