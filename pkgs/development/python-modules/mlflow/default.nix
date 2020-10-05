{ stdenv, buildPythonPackage, fetchPypi, isPy27
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
, pytest
}:

buildPythonPackage rec {
  pname = "mlflow";
  version = "1.11.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "443d92761ac051c64f71ff51601a62c418a3f789642eda5238e933fc7c5bf5e2";
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

  meta = with stdenv.lib; {
    homepage = "https://github.com/mlflow/mlflow";
    description = "Open source platform for the machine learning lifecycle";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
    # missing prometheus-flask-exporter, not packaged in nixpkgs
    broken = true; # 2020-08-15
  };
}
