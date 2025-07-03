{
  lib,
  azure-common,
  azure-core,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  msrest,
  pythonOlder,
  requests,
  setuptools,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "azure-multiapi-storage";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "azure_multiapi_storage";
    inherit version;
    hash = "sha256-INTvVn+1ysQHKRyI0Q4p43Ynyyj2BiBPVMcfaAEDCyg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-core
    cryptography
    msrest
    requests
    python-dateutil
  ];

  # fix namespace
  pythonNamespaces = [ "azure.multiapi" ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.multiapi.storage"
  ];

  meta = {
    description = "Microsoft Azure Storage Client Library for Python with multi API version support";
    homepage = "https://github.com/Azure/azure-multiapi-storage-python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
