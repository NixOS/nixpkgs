{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

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
  msal,
  msrest,
  opentelemetry-api,
  pydash,
  pyjwt,
  pyyaml,
  six,
  strictyaml,
  tqdm,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-ai-ml";
  # nixpkgs-update: no auto update
  # Must match the azure-ai-ml== pin of azure-cli-extensions.ml, bump both together
  version = "1.35.1";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_ai_ml";
    inherit (finalAttrs) version;
    hash = "sha256-Ssj3f7VuB5PQEq4/mjhVCIOwcXW9rkdCVUzDw6F/AjE=";
  };

  # bool(NotImplemented) raises a TypeError since Python 3.14, which these
  # __ne__ implementations hit whenever __eq__ returns NotImplemented
  postPatch = ''
    substituteInPlace $(grep -rlF --include='*.py' 'return not self.__eq__(other)' azure/ai/ml) \
      --replace-fail 'return not self.__eq__(other)' 'return object.__ne__(self, other)'
  '';

  build-system = [ setuptools ];

  pythonRemoveDeps = [
    # Only imported lazily (and guarded) to configure telemetry inside Jupyter
    "azure-monitor-opentelemetry"
  ];

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
    pydash
    pyjwt
    pyyaml
    strictyaml
    tqdm
    typing-extensions
    # Imported, but not declared upstream
    msal
    msrest
    opentelemetry-api
    six
  ];

  pythonImportsCheck = [
    "azure.ai.ml"
    "azure.ai.ml.identity"
  ];

  # Tests are only available in mono repo
  doCheck = false;

  passthru.skipBulkUpdate = true;

  meta = {
    description = "Microsoft Azure Machine Learning Client Library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/ml/azure-ai-ml";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-ai-ml_${finalAttrs.version}/sdk/ml/azure-ai-ml/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bryanhonof ];
    # Requires marshmallow<4, use `.override { marshmallow = marshmallow_3; }`
    # https://github.com/Azure/azure-sdk-for-python/issues/41815
    broken = lib.versionAtLeast marshmallow.version "4";
  };
})
