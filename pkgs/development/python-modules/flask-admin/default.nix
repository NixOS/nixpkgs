{ lib
, arrow
, azure-storage-blob
, boto
, buildPythonPackage
, colour
, email-validator
, enum34
, fetchPypi
, flask
, flask-babelex
, flask-mongoengine
, flask-sqlalchemy
, geoalchemy2
, mongoengine
, pillow
, psycopg2
, pymongo
, pytestCheckHook
, pythonOlder
, shapely
, sqlalchemy
, sqlalchemy-citext
, sqlalchemy-utils
, wtf-peewee
, wtforms
}:

buildPythonPackage rec {
  pname = "flask-admin";
  version = "1.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "Flask-Admin";
    inherit version;
    hash = "sha256-JMrir4MramEaAdfcNfQtJmwdbHWkJrhp2MskG3gjM2k=";
  };

  propagatedBuildInputs = [
    flask
    wtforms
  ];

  passthru.optional-dependencies = {
    aws = [
      boto
    ];
    azure = [
      azure-storage-blob
    ];
  };

  nativeCheckInputs = [
    arrow
    colour
    email-validator
    flask-babelex
    flask-mongoengine
    flask-sqlalchemy
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
    # Tests are outdated and don't work with peewee
    "test_nested_flask_views"
    "test_export_csv"
    "test_list_row_actions"
    "test_column_editable_list"
    "test_column_filters"
    "test_export_csv"
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
    # RuntimeError: Working outside of application context.
    "flask_admin/tests/sqla/test_multi_pk.py"
  ];

  pythonImportsCheck = [
    "flask_admin"
  ];

  meta = with lib; {
    description = "Admin interface framework for Flask";
    homepage = "https://github.com/flask-admin/flask-admin/";
    changelog = "https://github.com/flask-admin/flask-admin/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
