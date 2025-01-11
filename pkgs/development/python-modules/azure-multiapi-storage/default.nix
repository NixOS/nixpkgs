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
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tlKogIs39tIoMVl3p/YConfPdPrpX9oc9WqQ+FuhgQk=";
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
