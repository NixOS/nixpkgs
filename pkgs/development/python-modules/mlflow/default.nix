{ lib, buildPythonPackage, fetchPypi, isPy27
, alembic
, click
, cloudpickle
, requests
, six
, flask
, numpy
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
}:

buildPythonPackage rec {
  pname = "mlflow";
  version = "1.21.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5524a371f19c66a18e7ebe9b1085a77f63a6ae514271e487428f28187d79fc8f";
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
  ];

  meta = with lib; {
    homepage = "https://github.com/mlflow/mlflow";
    description = "Open source platform for the machine learning lifecycle";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
    # missing prometheus-flask-exporter, not packaged in nixpkgs
    broken = true; # 2020-08-15
  };
}
