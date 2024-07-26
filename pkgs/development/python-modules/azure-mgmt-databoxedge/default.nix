{ lib, buildPythonPackage, fetchPypi
, msrestazure
, azure-common
, azure-mgmt-core
}:

buildPythonPackage rec {
  pname = "azure-mgmt-databoxedge";
  version = "1.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "04090062bc1e8f00c2f45315a3bceb0fb3b3479ec1474d71b88342e13499b087";
  };

  propagatedBuildInputs = [
    msrestazure
    azure-common
    azure-mgmt-core
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
