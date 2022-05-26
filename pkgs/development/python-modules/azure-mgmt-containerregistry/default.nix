{ lib
, buildPythonPackage
, fetchPypi
, azure-common
, azure-mgmt-core
, msrest
, msrestazure
, pythonOlder
}:

buildPythonPackage rec {
  pname = "azure-mgmt-containerregistry";
  version = "10.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HjejK28Em5AeoQ20o4fucnXTlAwADF/SEpVfHn9anZk=";
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

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.containerregistry"
  ];

  meta = with lib; {
    description = "Microsoft Azure Container Registry Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
