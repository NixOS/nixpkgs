{ lib, buildPythonPackage, fetchPypi, isPy27
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
}:

buildPythonPackage rec {
  version = "10.0.0";
  pname = "azure-mgmt-containerregistry";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HjejK28Em5AeoQ20o4fucnXTlAwADF/SEpVfHn9anZk=";
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
