{
  lib,
  buildPythonPackage,
  fetchPypi,

  # dependencies
  aiohttp,
  alembic,
  cachetools,
  click,
  cloudpickle,
  cryptography,
  databricks-sdk,
  docker,
  fastapi,
  flask,
  flask-cors,
  gitpython,
  graphene,
  gunicorn,
  huey,
  importlib-metadata,
  jinja2,
  markdown,
  matplotlib,
  numpy,
  opentelemetry-api,
  opentelemetry-proto,
  opentelemetry-sdk,
  packaging,
  pandas,
  protobuf,
  pyarrow,
  pydantic,
  python-dotenv,
  pyyaml,
  requests,
  scikit-learn,
  scipy,
  shap,
  skops,
  starlette,
  sqlalchemy,
  sqlparse,
  uvicorn,
}:

buildPythonPackage rec {
  pname = "mlflow";
  version = "3.12.0";
  format = "wheel";

  src = fetchPypi {
    pname = "mlflow";
    inherit version;
    format = "wheel";
    dist = "py3";
    python = "py3";
    hash = "sha256-4cKO1MSFV8xSx2bxfxylgmdT3fJB1D8w+ZxF9+prPOA=";
  };

  # Nix-wrapped python populates sys.path via NIX_PYTHONPATH/site hooks,
  # but PYTHONPATH stays unset in os.environ. mlflow spawns the server
  # in a subprocess with a curated env, so without this patch the child
  # interpreter cannot import uvicorn / mlflow itself.
  postInstall = ''
    patch -p1 -d "$out/lib/python"*/site-packages < ${./subprocess-pythonpath.patch}
  '';

  # mlflow on PyPI is three overlapping wheels (mlflow-skinny, mlflow-tracing,
  # mlflow). The full wheel declares the other two as runtime deps, so we strip
  # those declarations and inline their requirements into dependencies below.
  pythonRemoveDeps = [
    "mlflow-skinny"
    "mlflow-tracing"
  ];

  dependencies = [
    aiohttp
    alembic
    cachetools
    click
    cloudpickle
    cryptography
    databricks-sdk
    docker
    fastapi
    flask
    flask-cors
    gitpython
    graphene
    gunicorn
    huey
    importlib-metadata
    jinja2
    markdown
    matplotlib
    numpy
    opentelemetry-api
    opentelemetry-proto
    opentelemetry-sdk
    packaging
    pandas
    protobuf
    pyarrow
    pydantic
    python-dotenv
    pyyaml
    requests
    scikit-learn
    scipy
    shap
    skops
    starlette
    sqlalchemy
    sqlparse
    uvicorn
  ];

  pythonRelaxDeps = [
    "importlib_metadata"
  ];

  pythonImportsCheck = [ "mlflow" ];

  doCheck = false;

  meta = {
    description = "Open source platform for the machine learning lifecycle";
    mainProgram = "mlflow";
    homepage = "https://github.com/mlflow/mlflow";
    changelog = "https://github.com/mlflow/mlflow/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
