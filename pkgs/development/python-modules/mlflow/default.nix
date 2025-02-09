{ lib
, alembic
, buildPythonPackage
, click
, cloudpickle
, databricks-cli
, docker
, entrypoints
, fetchpatch
, fetchPypi
, flask
, gitpython
, gorilla
, gunicorn
, importlib-metadata
, markdown
, matplotlib
, numpy
, packaging
, pandas
, prometheus-flask-exporter
, protobuf
, python-dateutil
, pythonOlder
, pythonRelaxDepsHook
, pyarrow
, pytz
, pyyaml
, querystring_parser
, requests
, scikit-learn
, scipy
, shap
, simplejson
, sqlalchemy
, sqlparse
}:

buildPythonPackage rec {
  pname = "mlflow";
  version = "2.7.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3q8PXydgjpUm1p//zKcMgirJDqKQpvPkuz36GyCbARE=";
  };

  postPatch = ''
    substituteInPlace requirements/core-requirements.txt \
      --replace "gunicorn<21" "gunicorn"
  '';

  # Remove currently broken dependency `shap`, a model explainability package.
  # This seems quite unprincipled especially with tests not being enabled,
  # but not mlflow has a 'skinny' install option which does not require `shap`.
  nativeBuildInputs = [ pythonRelaxDepsHook ];
  pythonRemoveDeps = [ "shap" ];
  pythonRelaxDeps = [ "pytz" "pyarrow" ];

  propagatedBuildInputs = [
    alembic
    click
    cloudpickle
    databricks-cli
    docker
    entrypoints
    flask
    gitpython
    gorilla
    gunicorn
    importlib-metadata
    markdown
    matplotlib
    numpy
    packaging
    pandas
    prometheus-flask-exporter
    protobuf
    python-dateutil
    pyarrow
    pytz
    pyyaml
    querystring_parser
    requests
    scikit-learn
    scipy
    #shap
    simplejson
    sqlalchemy
    sqlparse
  ];

  pythonImportsCheck = [
    "mlflow"
  ];

  # no tests in PyPI dist
  # run into https://stackoverflow.com/questions/51203641/attributeerror-module-alembic-context-has-no-attribute-config
  # also, tests use conda so can't run on NixOS without buildFHSEnv
  doCheck = false;

  meta = with lib; {
    description = "Open source platform for the machine learning lifecycle";
    homepage = "https://github.com/mlflow/mlflow";
    changelog = "https://github.com/mlflow/mlflow/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
