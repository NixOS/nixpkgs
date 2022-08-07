{ lib
, arrow
, buildPythonPackage
, colour
, email-validator
, enum34
, fetchPypi
, flask
, flask-sqlalchemy
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
  version = "1.6.0";
  format = "setuptools";

  src = fetchPypi {
    pname = "Flask-Admin";
    inherit version;
    sha256 = "1209qhm51d4z66mbw55cmkzqvr465shnws2m2l2zzpxhnxwzqks2";
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
    email-validator
    flask-sqlalchemy
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

  disabledTests = [
    # Incompatible with werkzeug 2.1
    "test_mockview"
  ];

  disabledTestPaths = [
    # Tests have additional requirements
    "flask_admin/tests/geoa/test_basic.py"
    "flask_admin/tests/mongoengine/test_basic.py"
    "flask_admin/tests/pymongo/test_basic.py"
    "flask_admin/tests/sqla/test_basic.py"
    "flask_admin/tests/sqla/test_form_rules.py"
    "flask_admin/tests/sqla/test_inlineform.py"
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
