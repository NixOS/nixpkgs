{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.5.0";
  pname = "azure-mgmt-kusto";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0r6j3yp7ys0zgszqdjm6y90nigsapni4xhfpfgyk5c5qbgdpl93w";
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
