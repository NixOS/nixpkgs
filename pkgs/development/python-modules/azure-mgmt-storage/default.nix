{
  lib,
  buildPythonPackage,
  fetchPypi,
  azure-mgmt-common,
  azure-mgmt-core,
  isodate,
  setuptools,
}:

buildPythonPackage rec {
  pname = "azure-mgmt-storage";
  version = "25.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_storage";
    inherit version;
    hash = "sha256-vE/h6ib4xYv5yms2UJXP0ybWXO+hNd1fKeCTU8tjE+w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-mgmt-common
    azure-mgmt-core
    isodate
  ];

  pythonNamespaces = [ "azure.mgmt" ];

  pythonImportsCheck = [ "azure.mgmt.storage" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "This is the Microsoft Azure Storage Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-storage_${version}/sdk/storage/azure-mgmt-storage/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
