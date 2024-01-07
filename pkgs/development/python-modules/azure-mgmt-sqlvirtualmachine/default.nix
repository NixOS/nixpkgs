{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.5.0";
  format = "setuptools";
  pname = "azure-mgmt-sqlvirtualmachine";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1b9am8raa17hxnz7d5pk2ix0309wsnhnchq1mi22icd728sl5adm";
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

  pythonImportsCheck = [ "azure.common" "azure.mgmt.sqlvirtualmachine" ];

  meta = with lib; {
    description = "Microsoft Azure SQL Virtual Machine Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
