{
  lib,
  azure-storage-blob,
  buildPythonPackage,
  fetchpatch,
  fetchFromGitHub,
  flask,
  flask-mongoengine,
  flask-sqlalchemy,
  geoalchemy2,
  mongoengine,
  pillow,
  psycopg2,
  pymongo,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  shapely,
  sqlalchemy,
  wtf-peewee,
  wtforms,
}:

buildPythonPackage rec {
  pname = "flask-admin";
  version = "1.6.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "flask-admin";
    repo = "flask-admin";
    rev = "refs/tags/v${version}";
    hash = "sha256-L8Q9uPpoen6ZvuF2bithCMSgc6X5khD1EqH2FJPspZc=";
  };

  patches = [
    # https://github.com/flask-admin/flask-admin/pull/2374
    (fetchpatch {
      name = "pillow-10-compatibility.patch";
      url = "https://github.com/flask-admin/flask-admin/commit/96b92deef8b087e86a9dc3e84381d254ea5c0342.patch";
      hash = "sha256-iR5kxyeZaEyved5InZuPmcglTD77zW18/eSHGwOuW40=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    flask
    wtforms
  ];

  optional-dependencies = {
    azure = [ azure-storage-blob ];
  };

  nativeCheckInputs = [
    pillow
    mongoengine
    pymongo
    wtf-peewee
    sqlalchemy
    flask-mongoengine
    flask-sqlalchemy
    # flask-babelex # broken and removed
    shapely
    geoalchemy2
    psycopg2
    pytestCheckHook
  ];

  disabledTestPaths = [
    # depends on flask-babelex
    "flask_admin/tests/sqla/test_basic.py"
    "flask_admin/tests/sqla/test_form_rules.py"
    "flask_admin/tests/sqla/test_multi_pk.py"
    "flask_admin/tests/sqla/test_postgres.py"
    "flask_admin/tests/sqla/test_translation.py"
    # broken
    "flask_admin/tests/sqla/test_inlineform.py"
    "flask_admin/tests/test_model.py"
    "flask_admin/tests/fileadmin/test_fileadmin.py"
    # requires database
    "flask_admin/tests/geoa/test_basic.py"
    "flask_admin/tests/pymongo/test_basic.py"
    "flask_admin/tests/mongoengine/test_basic.py"
    "flask_admin/tests/peeweemodel/test_basic.py"
  ];

  pythonImportsCheck = [ "flask_admin" ];

  meta = with lib; {
    description = "Admin interface framework for Flask";
    homepage = "https://github.com/flask-admin/flask-admin/";
    changelog = "https://github.com/flask-admin/flask-admin/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nickcao ];
  };
}
