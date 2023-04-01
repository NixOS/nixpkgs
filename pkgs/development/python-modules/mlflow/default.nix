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
, GitPython
, gorilla
, gunicorn
, importlib-metadata
, numpy
, packaging
, pandas
, prometheus-flask-exporter
, protobuf
, python-dateutil
, pythonOlder
, pyyaml
, querystring_parser
, requests
, scipy
, simplejson
, six
, sqlalchemy
, sqlparse
}:

buildPythonPackage rec {
  pname = "mlflow";
  version = "1.30.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ln1R9uLcbMIxbnLc9BNSF8WByPTx+d3hBmqrqeCyLHo=";
  };

  propagatedBuildInputs = [
    alembic
    click
    cloudpickle
    databricks-cli
    docker
    entrypoints
    flask
    GitPython
    gorilla
    gunicorn
    importlib-metadata
    numpy
    packaging
    pandas
    prometheus-flask-exporter
    protobuf
    python-dateutil
    pyyaml
    querystring_parser
    requests
    scipy
    simplejson
    six
    sqlalchemy
    sqlparse
  ];

  pythonImportsCheck = [
    "mlflow"
  ];

  # run into https://stackoverflow.com/questions/51203641/attributeerror-module-alembic-context-has-no-attribute-config
  # also, tests use conda so can't run on NixOS without buildFHSUserEnv
  doCheck = false;

  meta = with lib; {
    description = "Open source platform for the machine learning lifecycle";
    homepage = "https://github.com/mlflow/mlflow";
    license = licenses.asl20;
    maintainers = with maintainers; [ tbenst ];
    knownVulnerabilities = [
      "CVE-2023-1176"
      "CVE-2023-1177"
    ];
  };
}
