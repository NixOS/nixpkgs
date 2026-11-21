{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
  runCommand,

  # build-system
  setuptools,
  wheel,

  # dependencies
  azure-core,
  azure-identity,
  azure-mgmt-core,
  azure-storage-blob,
  azure-storage-file-datalake,
  azure-storage-file-share,
  colorama,
  isodate,
  jsonschema,
  marshmallow_3,
  msrest,
  opentelemetry-api,
  pydash,
  pyjwt,
  pyyaml,
  strictyaml,
  tqdm,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "azure-ai-ml";
  version = "1.35.2";
  pyproject = true;

  src = fetchPypi {
    pname = "azure_ai_ml";
    inherit (finalAttrs) version;
    hash = "sha256-/bC1F1W3CBlih5LxmOmJWvgsnvtHIdcx635hGfTI/x0=";
  };

  build-system = [
    setuptools
    wheel
  ];

  # Only used to send telemetry from notebooks, and not packaged in nixpkgs
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
    # Upstream requires marshmallow < 4
    marshmallow_3
    pydash
    pyjwt
    pyyaml
    strictyaml
    tqdm
    typing-extensions

    # Imported directly, but upstream only gets them through azure-monitor-opentelemetry
    azure-identity
    msrest
    opentelemetry-api
  ];

  # The tests need devtools_testutils from the azure-sdk-for-python repository
  doCheck = false;

  pythonImportsCheck = [
    "azure.ai.ml"
    "azure.ai.ml.identity"
  ];

  passthru.tests.load-job =
    runCommand "azure-ai-ml-load-job-test"
      {
        nativeBuildInputs = [ (python.withPackages (ps: [ ps.azure-ai-ml ])) ];
      }
      ''
        python ${./tests/load_job.py} ${./tests/job.yml}
        touch $out
      '';

  meta = {
    description = "Microsoft Azure Machine Learning client library for Python";
    homepage = "https://github.com/Azure/azure-sdk-for-python/tree/main/sdk/ml/azure-ai-ml";
    changelog = "https://github.com/Azure/azure-sdk-for-python/blob/azure-ai-ml_${finalAttrs.version}/sdk/ml/azure-ai-ml/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ takishima ];
  };
})
