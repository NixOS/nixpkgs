{
  lib,
  alembic,
  buildPythonPackage,
  cachetools,
  click,
  cloudpickle,
  databricks-cli,
  docker,
  entrypoints,
  fetchPypi,
  flask,
  gitpython,
  gorilla,
  graphene,
  gunicorn,
  importlib-metadata,
  markdown,
  matplotlib,
  numpy,
  opentelemetry-api,
  opentelemetry-sdk,
  packaging,
  pandas,
  prometheus-flask-exporter,
  protobuf,
  python-dateutil,
  pythonOlder,
  pyarrow,
  pytz,
  pyyaml,
  querystring-parser,
  requests,
  setuptools,
  scikit-learn,
  scipy,
  simplejson,
  sqlalchemy,
  sqlparse,
}:

buildPythonPackage rec {
  pname = "mlflow";
  version = "2.14.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KSyuS4NXSgyyIxF+IkyqZ5iTMHivAjNxnCthK+pkVhc=";
  };

  # Remove currently broken dependency `shap`, a model explainability package.
  # This seems quite unprincipled especially with tests not being enabled,
  # but not mlflow has a 'skinny' install option which does not require `shap`.
  pythonRemoveDeps = [ "shap" ];
  pythonRelaxDeps = [
    "gunicorn"
    "packaging"
    "pytz"
    "pyarrow"
  ];

  propagatedBuildInputs = [
    alembic
    cachetools
    click
    cloudpickle
    databricks-cli
    docker
    entrypoints
    flask
    gitpython
    gorilla
    graphene
    gunicorn
    importlib-metadata
    markdown
    matplotlib
    numpy
    opentelemetry-api
    opentelemetry-sdk
    packaging
    pandas
    prometheus-flask-exporter
    protobuf
    pyarrow
    python-dateutil
    pytz
    pyyaml
    querystring-parser
    requests
    scikit-learn
    scipy
    setuptools
    #shap
    simplejson
    sqlalchemy
    sqlparse
  ];

  pythonImportsCheck = [ "mlflow" ];

  # no tests in PyPI dist
  # run into https://stackoverflow.com/questions/51203641/attributeerror-module-alembic-context-has-no-attribute-config
  # also, tests use conda so can't run on NixOS without buildFHSEnv
  doCheck = false;

  meta = with lib; {
    description = "Open source platform for the machine learning lifecycle";
    mainProgram = "mlflow";
    homepage = "https://github.com/mlflow/mlflow";
    changelog = "https://github.com/mlflow/mlflow/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
