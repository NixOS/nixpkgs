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
  version = "10.3.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NLkpVq773VccrloD9weOA32Ah7LADPpnSINdxzq7WjA=";
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
