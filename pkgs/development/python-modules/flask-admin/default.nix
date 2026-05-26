{
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  lib,
  # dependencies
  flask,
  jinja2,
  markupsafe,
  werkzeug,
  wtforms,
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
}:

buildPythonPackage rec {
  pname = "flask-admin";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flask-admin";
    repo = "flask-admin";
    tag = "v${version}";
    hash = "sha256-HjK+ddMtT8QJ/KSFj9v28jflf2f6M+Gx1rJjCdWUUFM=";
  };

  build-system = [ flit-core ];

  dependencies = [
    flask
    jinja2
    markupsafe
    werkzeug
    wtforms
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
    # requires database
    "flask_admin/tests/geoa/test_basic.py"
    "flask_admin/tests/pymongo/test_basic.py"
    "flask_admin/tests/mongoengine/test_basic.py"
    "flask_admin/tests/peeweemodel/test_basic.py"
    "flask_admin/tests/sqla/test_postgres.py"
    # requires internet
    "flask_admin/tests/fileadmin/test_fileadmin_azure.py"
  ];

  pythonImportsCheck = [ "flask_admin" ];

  meta = {
    description = "Admin interface framework for Flask";
    homepage = "https://github.com/flask-admin/flask-admin/";
    changelog = "https://github.com/flask-admin/flask-admin/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
