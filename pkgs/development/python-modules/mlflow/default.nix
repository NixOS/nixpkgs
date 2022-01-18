{ lib, buildPythonPackage, fetchPypi, isPy27, fetchpatch
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
, prometheus-flask-exporter
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "mlflow";
  version = "1.22.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f680390715e436ae38cf7056ec91030fc9eb67cc631226f28ff9504fbe395add";
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
    prometheus-flask-exporter
    importlib-metadata
  ];

  patches = [
    # Relex alembic version, https://github.com/mlflow/mlflow/pull/5245
    (fetchpatch {
      name = "relax-alembic-version.patch";
      url = "https://github.com/mlflow/mlflow/commit/945eb4b67f315c0b2c4018b1df006fde910f115f.patch";
      sha256 = "sha256-jETVEPzlNe0PvFZVOi1SwgJELfx/KCeq6REL3vl+YT0=";
    })
  ];

  meta = with lib; {
    homepage = "https://github.com/mlflow/mlflow";
    description = "Open source platform for the machine learning lifecycle";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
  };
}
