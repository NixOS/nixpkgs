{
  lib,
  azure-common,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-servicefabricmanagedclusters";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Bw+pMc0H9Gk8t4vaaOgwSMZ/zqzUJHGZ7keH+ylZnVw=";
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

  meta = with lib; {
    description = "This is the Microsoft Azure Service Fabric Cluster Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/servicefabricmanagedclusters/azure-mgmt-servicefabricmanagedclusters";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-servicefabricmanagedclusters_${version}/sdk/servicefabricmanagedclusters/azure-mgmt-servicefabricmanagedclusters/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
