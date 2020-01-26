{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.3.0";
  pname = "azure-mgmt-appconfiguration";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1igl3ikdwcz7d2zcja5nm2qjysjh53vgwzcc96lylypmq6z4aq1s";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.appconfiguration" ];

  meta = with lib; {
    description = "Microsoft Azure App Configuration Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
