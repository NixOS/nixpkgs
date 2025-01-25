{
  lib,
  azure-common,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-servicemanagement-legacy";
  version = "0.20.8";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_servicemanagement_legacy";
    inherit version;
    hash = "sha256-42neKpeBjx26GTIzeBTyjTmj5tcNklNQoaBoEDjC+Xc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    requests
  ];

  pythonNamespaces = [ "azure" ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "azure.servicemanagement" ];

  meta = with lib; {
    description = "This is the Microsoft Azure Service Management Legacy Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/core/azure-servicemanagement-legacy";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-servicemanagement-legacy_${version}/sdk/core/azure-servicemanagement-legacy/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      olcai
      maxwilson
    ];
  };
}
