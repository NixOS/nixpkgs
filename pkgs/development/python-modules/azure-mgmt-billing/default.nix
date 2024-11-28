{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-billing";
  version = "7.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_mgmt_billing";
    inherit version;
    hash = "sha256-jgplxlEQtTpCk35b7WrgDvydYgaXLZa/1KdOgMhcLXs=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "This is the Microsoft Azure Billing Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/billing/azure-mgmt-billing";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-billing_${version}/sdk/billing/azure-mgmt-billing/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ maxwilson ];
  };
}
