{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-core
, msrest
}:

buildPythonPackage rec {
  pname = "azure-mgmt-servicelinker";
  version = "1.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QVw6Y9HachwBRwCbF0cSGLCAkSJtNnXBvsj5YX1TmJU=";
    extension = "zip";
  };

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    msrest
  ];

  pythonImportsCheck = [ "azure.mgmt.servicelinker" ];

  # no tests with sdist
  doCheck = false;

  meta = with lib; {
    description = "Microsoft Azure Servicelinker Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
