{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-mgmt-servicefabricmanagedclusters";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_servicefabricmanagedclusters";
    inherit (finalAttrs) version;
    hash = "sha256-6JcaQubkkT9IWr9NRRQBGwvYbNQeFQovh9yHWO/P984=";
  };

  build-system = [ setuptools ];

  dependencies = [
    isodate
    azure-common
    azure-mgmt-core
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  # Module has tests in mono-repo
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure Service Fabric Cluster Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/servicefabricmanagedclusters/azure-mgmt-servicefabricmanagedclusters";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-servicefabricmanagedclusters_${finalAttrs.version}/sdk/servicefabricmanagedclusters/azure-mgmt-servicefabricmanagedclusters/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
