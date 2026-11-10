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
  pname = "azure-mgmt-commerce";
  version = "6.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-b1RHOVUDsjGPRR0k+AIe4I2xysRPHDM36mkHAEGWJrY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrestazure
    azure-common
    azure-mgmt-core
    azure-mgmt-nspkg
  ];

  prePatch = ''
    rm -f azure_bdist_wheel.py tox.ini
    sed -i "/azure-namespace-package/c\ " setup.cfg
  '';

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;
  pythonImportsCheck = [ "azure.mgmt.commerce" ];

  meta = {
    description = "This is the Microsoft Azure Commerce Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
