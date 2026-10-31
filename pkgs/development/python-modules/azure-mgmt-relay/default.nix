{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  azure-common,
  azure-mgmt-core,
  msrest,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-relay";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-yTt1UOZLZzS/I85XypdKPqkptzTFjR/jZpcoxP0tLrM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    azure-common
    azure-mgmt-core
  ];

  preBuild = ''
    rm -f azure_bdist_wheel.py
  '';

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.mgmt.relay" ];

  meta = {
    description = "This is the Microsoft Azure Relay Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
