{ lib
, arrow
, buildPythonPackage
, colour
, email_validator
, enum34
, fetchPypi
, flask
, flask_sqlalchemy
, flask-babelex
, flask-mongoengine
, geoalchemy2
, isPy27
, mongoengine
, pillow
, psycopg2
, pymongo
, pytestCheckHook
, shapely
, sqlalchemy
, sqlalchemy-citext
, sqlalchemy-utils
, wtf-peewee
, wtforms
}:

buildPythonPackage rec {
  pname = "flask-admin";
  version = "1.5.8";
  format = "setuptools";

  src = fetchPypi {
    pname = "Flask-Admin";
    inherit version;
    sha256 = "sha256-6wah8xuYiB3uU6VcZPrr0ZkNaqw4gmNksoDfCyZ5/3Q=";
  };

  propagatedBuildInputs = [
    flask
    wtforms
  ] ++ lib.optionals isPy27 [
    enum34
  ];

  checkInputs = [
    arrow
    colour
    email_validator
    flask_sqlalchemy
    flask-babelex
    flask-mongoengine
    geoalchemy2
    mongoengine
    pillow
    psycopg2
    pymongo
    pytestCheckHook
    shapely
    sqlalchemy
    sqlalchemy-citext
    sqlalchemy-utils
    wtf-peewee
  ];

  disabledTestPaths = [
    # Tests have additional requirements
    "flask_admin/tests/geoa/test_basic.py"
    "flask_admin/tests/mongoengine/test_basic.py"
    "flask_admin/tests/pymongo/test_basic.py"
    "flask_admin/tests/sqla/test_basic.py"
    "flask_admin/tests/sqla/test_form_rules.py"
    "flask_admin/tests/sqla/test_postgres.py"
    "flask_admin/tests/sqla/test_translation.py"
  ];

  pythonImportsCheck = [
    "flask_admin"
  ];

  meta = with lib; {
    description = "Simple and extensible admin interface framework for Flask";
    homepage = "https://github.com/flask-admin/flask-admin/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
