{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "9.1.0";
  pname = "azure-mgmt-containerregistry";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jkzGLDqrJgwCnz27lGzFk4d2q+j0P+PU8uUVGQg7MkA=";
    extension = "zip";
  };

  propagatedBuildInputs = [ azure-common azure-mgmt-core msrest msrestazure ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [ "azure.common" "azure.mgmt.containerregistry" ];

  meta = with lib; {
    description = "Microsoft Azure Container Registry Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
