{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mlflow,

  # build-system
  setuptools,

  # dependencies
  cachetools,
  click,
  cloudpickle,
  databricks-sdk,
  fastapi,
  gitpython,
  importlib-metadata,
  opentelemetry-api,
  opentelemetry-proto,
  opentelemetry-sdk,
  packaging,
  protobuf,
  pydantic,
  python-dotenv,
  pyyaml,
  requests,
  sqlparse,
  starlette,
  typing-extensions,
  uvicorn,
}:

buildPythonPackage (finalAttrs: {
  pname = "mlflow-skinny";
  inherit (mlflow) version;
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mlflow";
    repo = "mlflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GVa/O2nT0vJS6NG00NMGpyX+3Z+bbOarNe0ZZqCQrH8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "setuptools<=82.0.1" \
        "setuptools"
  '';

  sourceRoot = "${finalAttrs.src.name}/libs/skinny";

  build-system = [ setuptools ];

  dependencies = [
    cachetools
    click
    cloudpickle
    databricks-sdk
    fastapi
    gitpython
    importlib-metadata
    opentelemetry-api
    opentelemetry-proto
    opentelemetry-sdk
    packaging
    protobuf
    pydantic
    python-dotenv
    pyyaml
    requests
    sqlparse
    starlette
    typing-extensions
    uvicorn
  ];

  pythonImportsCheck = [ "mlflow" ];

  # No tests in the skinny subtree.
  doCheck = false;

  meta = mlflow.meta // {
    description = "Lightweight version of MLflow that is designed to minimize package size";
    homepage = "https://github.com/mlflow/mlflow/tree/master/libs/skinny";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
