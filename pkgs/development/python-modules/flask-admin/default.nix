{
<<<<<<< HEAD
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  lib,
  pythonOlder,
  # dependencies
  flask,
  jinja2,
  markupsafe,
  werkzeug,
  wtforms,
  typing-extensions,
  # optional dependencies
  # sqlalchemy
  flask-sqlalchemy,
  sqlalchemy,
  # sqlalchemy-with-utils
  arrow,
  colour,
  email-validator,
  sqlalchemy-citext,
  sqlalchemy-utils,
  # geoalchemy
  geoalchemy2,
  shapely,
  # pymongo
  pymongo,
  # mongoengine
  mongoengine,
  # peewee
  peewee,
  wtf-peewee,
  # s3
  boto3,
  # azure-blob-storage
  azure-storage-blob,
  # images
  pillow,
  # export
  tablib,
  # rediscli
  redis,
  # translation
  flask-babel,
  # checks
  beautifulsoup4,
  moto,
  psycopg2,
  pytestCheckHook,
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "flask-admin";
<<<<<<< HEAD
  version = "2.0.2";
  pyproject = true;

  disabled = pythonOlder "3.10";
=======
  version = "1.6.1";
  pyproject = true;

  disabled = pythonOlder "3.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "flask-admin";
    repo = "flask-admin";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-HjK+ddMtT8QJ/KSFj9v28jflf2f6M+Gx1rJjCdWUUFM=";
  };

  build-system = [ flit-core ];

  dependencies = [
    flask
    jinja2
    markupsafe
    werkzeug
    wtforms
  ]
  ++ lib.optionals (pythonOlder "3.11") [
    typing-extensions
  ];

  optional-dependencies = {
    sqlalchemy = [
      flask-sqlalchemy
      sqlalchemy
    ];
    sqlalchemy-with-utils = optional-dependencies.sqlalchemy ++ [
      arrow
      colour
      email-validator
      sqlalchemy-citext
      sqlalchemy-utils
    ];
    geoalchemy = optional-dependencies.sqlalchemy ++ [
      geoalchemy2
      shapely
    ];
    pymongo = [ pymongo ];
    mongoengine = [ mongoengine ];
    peewee = [
      peewee
      wtf-peewee
    ];
    s3 = [ boto3 ];
    azure-blob-storage = [ azure-storage-blob ];
    images = [ pillow ];
    export = [ tablib ];
    rediscli = [ redis ];
    translation = [ flask-babel ];
    all = lib.flatten [
      optional-dependencies.sqlalchemy
      optional-dependencies.sqlalchemy-with-utils
      optional-dependencies.geoalchemy
      optional-dependencies.pymongo
      optional-dependencies.mongoengine
      optional-dependencies.peewee
      optional-dependencies.s3
      optional-dependencies.azure-blob-storage
      optional-dependencies.images
      optional-dependencies.export
      optional-dependencies.rediscli
      optional-dependencies.translation
    ];
  };

  nativeCheckInputs = [
    beautifulsoup4
    moto
    psycopg2
    pytestCheckHook
  ]
  ++ lib.flatten [
    optional-dependencies.sqlalchemy-with-utils
    optional-dependencies.mongoengine
    optional-dependencies.peewee
    optional-dependencies.images
    optional-dependencies.export
    optional-dependencies.translation
    flask.optional-dependencies.async
  ];

  disabledTestPaths = [
=======
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
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # requires database
    "flask_admin/tests/geoa/test_basic.py"
    "flask_admin/tests/pymongo/test_basic.py"
    "flask_admin/tests/mongoengine/test_basic.py"
    "flask_admin/tests/peeweemodel/test_basic.py"
<<<<<<< HEAD
    "flask_admin/tests/sqla/test_postgres.py"
    # requires internet
    "flask_admin/tests/fileadmin/test_fileadmin_azure.py"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  pythonImportsCheck = [ "flask_admin" ];

<<<<<<< HEAD
  meta = {
    description = "Admin interface framework for Flask";
    homepage = "https://github.com/flask-admin/flask-admin/";
    changelog = "https://github.com/flask-admin/flask-admin/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
=======
  meta = with lib; {
    description = "Admin interface framework for Flask";
    homepage = "https://github.com/flask-admin/flask-admin/";
    changelog = "https://github.com/flask-admin/flask-admin/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nickcao ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
