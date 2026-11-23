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
  pname = "azure-mgmt-databricks";
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_databricks";
    inherit (finalAttrs) version;
    hash = "sha256-/eeIbyV4EU8/W5S9P33VOPLK8J9xSUzKMjU0qJNbOf8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    isodate
    azure-common
    azure-mgmt-core
  ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Microsoft Azure Data Bricks Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/databricks/azure-mgmt-databricks";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-mgmt-databricks_${finalAttrs.version}/sdk/databricks/azure-mgmt-databricks/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
