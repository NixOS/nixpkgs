{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-servicefabricmanagedclusters";
  version = "2.1.0b3";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_servicefabricmanagedclusters";
    inherit version;
    hash = "sha256-52i8y0V2qy3yDP/mJi7zATE0+qi5H+F8Zcjnoc2qQTU=";
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
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-servicefabricmanagedclusters_${version}/sdk/servicefabricmanagedclusters/azure-mgmt-servicefabricmanagedclusters/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
