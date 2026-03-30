{
  lib,
  azure-common,
  azure-core,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
}:

buildPythonPackage rec {
  pname = "azure-synapse-artifacts";
  version = "0.22.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "azure_synapse_artifacts";
    inherit version;
    hash = "sha256-3cD7Yic4w+q3RlzkKM+gzUGtAahw+9RTYeTVjRdcYjw=";
  };

  propagatedBuildInputs = [
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
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-synapse-artifacts_${version}/sdk/synapse/azure-synapse-artifacts/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
