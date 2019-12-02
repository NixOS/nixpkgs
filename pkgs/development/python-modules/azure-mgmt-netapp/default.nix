{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.6.0";
  pname = "azure-mgmt-netapp";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "10ymvyj386z9bjdm2g1b5a4vfnn87ig2zm6xn2xddvbpy0jxnyfv";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.netapp" ];

  meta = with lib; {
    description = "Microsoft Azure NetApp Files Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
