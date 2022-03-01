{ lib, buildPythonPackage, fetchPypi, isPy27, fetchpatch
, alembic
, click
, cloudpickle
, requests
, six
, flask
, numpy
, scipy
, pandas
, python-dateutil
, protobuf
, GitPython
, pyyaml
, querystring_parser
, simplejson
, docker
, databricks-cli
, entrypoints
, sqlparse
, sqlalchemy
, gorilla
, gunicorn
, prometheus-flask-exporter
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "mlflow";
  version = "1.24.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-6hZwiOuHtB8RFwgyfPeV8plLBPlnAdVP1f1bNah4en4=";
  };

  # run into https://stackoverflow.com/questions/51203641/attributeerror-module-alembic-context-has-no-attribute-config
  # also, tests use conda so can't run on NixOS without buildFHSUserEnv
  doCheck = false;

  propagatedBuildInputs = [
    alembic
    click
    cloudpickle
    requests
    six
    flask
    numpy
    scipy
    pandas
    python-dateutil
    protobuf
    GitPython
    pyyaml
    querystring_parser
    simplejson
    docker
    databricks-cli
    entrypoints
    sqlparse
    sqlalchemy
    gorilla
    gunicorn
    prometheus-flask-exporter
    importlib-metadata
  ];

  pythonImportsCheck = [ "mlflow" ];

  meta = with lib; {
    homepage = "https://github.com/mlflow/mlflow";
    description = "Open source platform for the machine learning lifecycle";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
