{
  lib,
  azure-common,
  azure-core,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-synapse-artifacts";
  version = "0.22.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "azure_synapse_artifacts";
    inherit (finalAttrs) version;
    hash = "sha256-3cD7Yic4w+q3RlzkKM+gzUGtAahw+9RTYeTVjRdcYjw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    azure-common
    azure-core
    azure-mgmt-core
    isodate
  ];

  # Tests are only available in mono-repo
  doCheck = false;

  pythonImportsCheck = [ "azure.synapse.artifacts" ];

  meta = {
    description = "Microsoft Azure Synapse Artifacts Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-synapse-artifacts_${finalAttrs.version}/sdk/synapse/azure-synapse-artifacts/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
