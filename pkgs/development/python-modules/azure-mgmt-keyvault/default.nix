{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  isodate,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-keyvault";
  version = "12.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_keyvault";
    inherit version;
    hash = "sha256-4s8Y6KSSi10cqxJ75C6prQJG1ofKEvwnoq1mSHzhyGs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.keyvault" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Key Vault Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-keyvault_${version}/sdk/keyvault/azure-mgmt-keyvault/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
