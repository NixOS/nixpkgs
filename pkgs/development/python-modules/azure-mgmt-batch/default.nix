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
  pname = "azure-mgmt-batch";
  version = "18.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_mgmt_batch";
    inherit version;
    hash = "sha256-MF61H7P3OyCSfvR7O2+T6eMtyTmHbARflwvThsB7p5w=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    azure-common
    azure-mgmt-core
    isodate
  ];

  # Tests are only available in mono repo
  doCheck = false;

  pythonImportsCheck = [ "azure.mgmt.batch" ];

  meta = {
    description = "This is the Microsoft Azure Batch Management Client Library";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/batch/azure-mgmt-batch";
    changelog = "https://github.com/Azure/azure-sdk-for-python/tree/azure-mgmt-batch_${version}/sdk/batch/azure-mgmt-batch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maxwilson ];
  };
}
