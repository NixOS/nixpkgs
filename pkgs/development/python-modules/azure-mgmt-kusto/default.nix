{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.7.0";
  pname = "azure-mgmt-kusto";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "40f8e62db145d31731018b83baf2d1a78b585514c373dd3c095f1f6835d17d23";
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
