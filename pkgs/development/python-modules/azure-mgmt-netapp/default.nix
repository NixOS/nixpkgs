{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "0.13.0";
  pname = "azure-mgmt-netapp";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e86034d073144bd5dbafe17e20fef3f48b5bf98a31b27cc0de462dc8f98303bb";
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
