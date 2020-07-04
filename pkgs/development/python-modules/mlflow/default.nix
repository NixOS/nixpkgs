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
  version = "1.8.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bab1b95da17ffb1856fec35fc1a0bc9d16e1811e41610a97c2c955884eb6ac53";
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
  };
}
