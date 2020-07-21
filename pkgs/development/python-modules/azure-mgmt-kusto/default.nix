{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.8.0";
  pname = "azure-mgmt-kusto";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b12388df60982265c9f18e7382c5cc0e389c071227865cadc626b9ff9c6e3871";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.kusto" ];

  meta = with lib; {
    description = "Microsoft Azure Kusto Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
