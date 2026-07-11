{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mlflow,

  # build-system
  setuptools,

  # dependencies
  cachetools,
  databricks-sdk,
  opentelemetry-api,
  opentelemetry-proto,
  opentelemetry-sdk,
  packaging,
  protobuf,
  pydantic,
}:
buildPythonPackage (finalAttrs: {
  pname = "mlflow-tracing";
  inherit (mlflow) version;
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mlflow";
    repo = "mlflow";
    rev = "v${finalAttrs.version}";
    hash = "sha256-e11ZncpvThb1Nt6OH+O6Do74N3dphxBiK/HIeLQMxAw=";
  };

  sourceRoot = "${finalAttrs.src.name}/libs/tracing";

  build-system = [ setuptools ];

  dependencies = [
    cachetools
    databricks-sdk
    opentelemetry-api
    opentelemetry-proto
    opentelemetry-sdk
    packaging
    protobuf
    pydantic
  ];

  pythonImportsCheck = [ "mlflow.tracing" ];

  # No tests
  doCheck = false;

  meta = {
    description = "Open-Source SDK for observability and monitoring GenAI applications";
    homepage = "https://github.com/mlflow/mlflow/tree/master/libs/tracing";
    inherit (mlflow.meta) license;
    maintainers = with lib.maintainers; [
      GaetanLepage
      gquetel
    ];
  };
})
