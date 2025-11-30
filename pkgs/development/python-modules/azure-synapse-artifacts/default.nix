{
  lib,
  azure-common,
  azure-core,
  azure-mgmt-core,
  buildPythonPackage,
  fetchPypi,
  isodate,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "azure-synapse-artifacts";
  version = "0.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "azure_synapse_artifacts";
    inherit version;
    hash = "sha256-1+N1Fs+FaeA8YE2SHjQH1xQM91I7Z7Z/dXyvmZ48juc=";
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

  meta = with lib; {
    description = "Microsoft Azure Synapse Artifacts Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-synapse-artifacts_${version}/sdk/synapse/azure-synapse-artifacts/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
