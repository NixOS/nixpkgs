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
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    extension = "zip";
    hash = "sha256-cNETYtwtF/X7HbDP5lwa9VuPE28aDbmltR56z3YM9bk=";
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
