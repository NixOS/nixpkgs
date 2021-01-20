{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.10.0";
  pname = "azure-mgmt-kusto";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "09e8d4928e19d12feb374adb47651b474f3ee3bc6a12704e4b70c9b38e3bcd9e";
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
