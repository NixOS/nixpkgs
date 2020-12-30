{ lib, buildPythonPackage, fetchPypi
, msrestazure
, azure-common
}:

buildPythonPackage rec {
  pname = "azure-mgmt-databoxedge";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "g8BtUpIGOse8Jrws48gQ/o7sgymlgX0XIxl1ThHS3XA=";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
  ];

  # no tests in pypi tarball
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.databoxedge" ];

  meta = with lib; {
    description = "Microsoft Azure Databoxedge Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
