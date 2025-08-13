{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  isodate,
  azure-common,
  azure-mgmt-core,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-msi";
  version = "7.1.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchPypi {
    pname = "azure_mgmt_msi";
    inherit version;
    hash = "sha256-GgGgifH2bLDUsohmA9W6QV82Dv8L5vaFc37N1Zx4Ils=";
  };

  build-system = [ setuptools ];

  dependencies = [
    isodate
    azure-common
    azure-mgmt-core
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.msi" ];

  meta = with lib; {
    description = "This is the Microsoft Azure MSI Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-msi";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-msi_${version}/sdk/resources/azure-mgmt-msi/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
