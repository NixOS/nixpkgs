{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  msrest,
  azure-common,
  azure-mgmt-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-msi";
  version = "7.1.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_msi";
    inherit version;
    hash = "sha256-GgGgifH2bLDUsohmA9W6QV82Dv8L5vaFc37N1Zx4Ils=";
  };

  build-system = [ setuptools ];

  dependencies = [
    msrest
    azure-common
    azure-mgmt-core
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.msi" ];

  meta = with lib; {
    description = "This is the Microsoft Azure MSI Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-msi";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
