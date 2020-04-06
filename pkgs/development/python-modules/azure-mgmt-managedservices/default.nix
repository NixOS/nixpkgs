{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "azure-mgmt-managedservices";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "06ddfqriqlvwjsjhqka9r5vhshardyj9c10xgjissfkpqsgkkn7y";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.managedservices" ];

  meta = with lib; {
    description = "Microsoft Azure Managed Services Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
