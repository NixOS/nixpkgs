{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-core,
  azure-common,
  isodate,
  pythonOlder,
  setuptools,
  typing-extensions,
  azure-cli,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-resource-deploymentscripts";
  version = "1.0.0b1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "azure_mgmt_resource_deploymentscripts";
    inherit version;
    hash = "sha256-Vm2FWVPpSbsrNMtD4ecwVKqnkoHHRhO3Rf/duCyAI3U=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-mgmt-core
    isodate
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonNamespaces = [
    "azure.mgmt.resource.deploymentscripts"
  ];

  pythonImportsCheck = [
    "azure.mgmt.resource.deploymentscripts"
  ];

  meta = with lib; {
    description = "Microsoft Azure SDK for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/resources/azure-mgmt-resource-deploymentscripts";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-resource-deploymentscripts_${version}/sdk/resources/azure-mgmt-resource-deploymentscripts/CHANGELOG.md";
    license = licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
