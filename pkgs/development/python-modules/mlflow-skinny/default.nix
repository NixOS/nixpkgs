{
  buildPythonPackage,
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
  inherit (mlflow) version src;
  pyproject = true;
  __structuredAttrs = true;

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
  };
})
