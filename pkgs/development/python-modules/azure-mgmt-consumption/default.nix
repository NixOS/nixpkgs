{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  msrestazure,
  azure-common,
  azure-mgmt-core,
  azure-mgmt-nspkg,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-consumption";
  version = "10.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-BqCGQ2wXN/d6uGiU1R9Zc7bg+l7fVlWOTCllieurkTA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrestazure
    azure-common
    azure-mgmt-core
    azure-mgmt-nspkg
  ];

  preBuild = ''
    rm -f azure_bdist_wheel.py
  '';

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Consumption Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
