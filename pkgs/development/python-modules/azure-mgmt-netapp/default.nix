{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "4.0.0";
  pname = "azure-mgmt-netapp";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7195e413a0764684cd42bec9e429c13c290db9ab5c465dbed586a6f6d0ec8a42";
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

  pythonImportsCheck = [ "azure.common" "azure.mgmt.netapp" ];

  meta = with lib; {
    description = "Microsoft Azure NetApp Files Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
