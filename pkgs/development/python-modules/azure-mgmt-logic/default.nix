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
  pname = "azure-mgmt-logic";
  version = "10.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-s/pIZPFKqnr0HXeNkl8FHtKbYBb0Y0R2Xs0PSdDwTdY=";
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

  pythonImportsCheck = [ "azure.mgmt.logic" ];

  meta = {
    description = "This is the Microsoft Azure Logic Apps Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
