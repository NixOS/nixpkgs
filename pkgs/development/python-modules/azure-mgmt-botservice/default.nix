{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  msrest,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-botservice";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hsBNJ8UnwZ2WAKiCFfriulJNxnRFU4ew0OUXIrWm1ro=";
    extension = "zip";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    msrest
  ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.mgmt.botservice"
  ];

  meta = with lib; {
    description = "Microsoft Azure API Management Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/botservice/azure-mgmt-botservice";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-mgmt-botservice_${version}/sdk/botservice/azure-mgmt-botservice";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
