{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, apispec_3
, colorama
, click
, email-validator
, flask
, flask-babel
, flask_login
, flask-openid
, flask_sqlalchemy
, flask-wtf_0
, flask-jwt-extended
, jsonschema
, marshmallow
, marshmallow-enum
, marshmallow-sqlalchemy
, python-dateutil
, pythonOlder
, prison
, pyjwt
, pyyaml
, sqlalchemy-utils
}:

buildPythonPackage rec {
  pname = "flask-appbuilder";
  version = "4.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-AppBuilder";
    inherit version;
    hash = "sha256-iQcTEbtcEVoJAVQIko/9m5A8NUkeOLwFFeoiFQPqkg4=";
  };


  propagatedBuildInputs = [
    apispec_3
    colorama
    click
    email-validator
    flask
    flask-babel
    flask_login
    flask-openid
    flask_sqlalchemy
    flask-wtf_0
    flask-jwt-extended
    jsonschema
    marshmallow
    marshmallow-enum
    marshmallow-sqlalchemy
    python-dateutil
    prison
    pyjwt
    pyyaml
    sqlalchemy-utils
  ];


  # Majority of tests require network access or mongo
  doCheck = false;

  pythonImportsCheck = [
    "flask_appbuilder"
  ];

  meta = with lib; {
    description = "Application development framework, built on top of Flask";
    homepage = "https://github.com/dpgaspar/flask-appbuilder/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
