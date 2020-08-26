{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.5.0";
  pname = "azure-mgmt-appconfiguration";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "211527511d7616a383cc196956eaf2b7ee016f2367d367924b3715f2a41106da";
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
