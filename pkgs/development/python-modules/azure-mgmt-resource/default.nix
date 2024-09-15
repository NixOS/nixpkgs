{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-core,
  azure-mgmt-common,
  msrest,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-resource";
  version = "23.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ILawBrVE/bGWB/P2o4EQViXgu2D78wNvOYhcRkbTND4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-mgmt-common
    azure-mgmt-core
    msrest
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.resource" ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [
      olcai
      maxwilson
    ];
  };
}
