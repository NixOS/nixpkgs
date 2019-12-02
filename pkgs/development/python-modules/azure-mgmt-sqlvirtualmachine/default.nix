{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.4.0";
  pname = "azure-mgmt-sqlvirtualmachine";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jxmikjvyxkwr8c9kn6xw8gvj9pajlk7y8111rq8fgkivwjq8wcm";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.sqlvirtualmachine" ];

  meta = with lib; {
    description = "Microsoft Azure SQL Virtual Machine Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
