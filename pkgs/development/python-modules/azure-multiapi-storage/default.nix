{
  lib,
  azure-common,
  azure-core,
  buildPythonPackage,
  cryptography,
  fetchPypi,
  msrest,
  msrestazure,
  pythonOlder,
  requests,
  setuptools,
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
    msrestazure
    requests
  ];

  # fix namespace
  pythonNamespaces = [ "azure.multiapi" ];

  # no tests included
  doCheck = false;

  pythonImportsCheck = [
    "azure.common"
    "azure.multiapi.storage"
  ];

  meta = with lib; {
    description = "Microsoft Azure Storage Client Library for Python with multi API version support";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = [ ];
  };
}
