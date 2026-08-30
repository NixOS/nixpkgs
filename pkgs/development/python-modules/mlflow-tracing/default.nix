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
    tag = "v${finalAttrs.version}";
    hash = "sha256-G5PybKonwsAg1MLOF9wc10RJE0x948+EVbcDq1+94mc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "setuptools<=82.0.1" \
        "setuptools"
  '';

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
