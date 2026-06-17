{
  lib,
  buildPythonPackage,
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

  # tests
  pytestCheckHook,
}:
buildPythonPackage (finalAttrs: {
  pname = "mlflow-tracing";
  inherit (mlflow) version;
  pyproject = true;
  __structuredAttrs = true;

  inherit (mlflow) src;

  sourceRoot = "${finalAttrs.src.name}/libs/tracing";

  build-system = [
    setuptools
  ];

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
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
