{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  wheel,

  # dependencies
  azure-core,
  azure-mgmt-core,
  azure-storage-blob,
  azure-storage-file-datalake,
  azure-storage-file-share,
  colorama,
  isodate,
  jsonschema,
  marshmallow,
  msrest,
  opentelemetry-api,
  pydash,
  pyjwt,
  pyyaml,
  strictyaml,
  tqdm,
  typing-extensions,

  azure-cli,
}:

buildPythonPackage rec {
  pname = "azure-ai-ml";
  version = "1.34.0";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_ai_ml";
    inherit version;
    hash = "sha256-exHmaklNMoAihH6bk2fbNKdE/7ojohmMe1hwKLKWVyw=";
  };

  build-system = [
    setuptools
    wheel
  ];

  # Only imported lazily on the App Insights telemetry path.
  pythonRemoveDeps = [ "azure-monitor-opentelemetry" ];

  dependencies = [
    azure-core
    azure-mgmt-core
    azure-storage-blob
    azure-storage-file-datalake
    azure-storage-file-share
    colorama
    isodate
    jsonschema
    marshmallow
    msrest
    opentelemetry-api
    pydash
    pyjwt
    pyyaml
    strictyaml
    tqdm
    typing-extensions
  ];

  # Tests require network access and additional azureml packages not in nixpkgs.
  doCheck = false;

  pythonImportsCheck = [ "azure.ai.ml" ];

  meta = {
    description = "Microsoft Azure Machine Learning Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/ml/azure-ai-ml";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-ai-ml_${version}/sdk/ml/azure-ai-ml/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = azure-cli.meta.maintainers;
  };
}
