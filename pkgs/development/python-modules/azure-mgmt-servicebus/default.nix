{
  lib,
  buildPythonPackage,
  fetchPypi,
  msrest,
  azure-common,
  azure-mgmt-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-servicebus";
  version = "8.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-i+kgjxQdmnifaNuNIZdU/3gGn9j5OQ6fdkS7laO+nsI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    azure-common
    azure-mgmt-core
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.servicebus" ];

  meta = {
    description = "This is the Microsoft Azure Service Bus Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
