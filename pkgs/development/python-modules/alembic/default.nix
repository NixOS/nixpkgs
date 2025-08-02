{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  importlib-metadata,
  importlib-resources,
  mako,
  sqlalchemy,
  typing-extensions,

  # tests
  pytest7CheckHook,
  pytest-xdist,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.15.2";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HHI5G73v/M/jF+77pobLmjwHgAVHiIVBO5XDsmxXqKc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mako
    sqlalchemy
    typing-extensions
  ]
  ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
    importlib-metadata
  ];

  pythonImportsCheck = [ "alembic" ];

  nativeCheckInputs = [
    pytest7CheckHook
    pytest-xdist
    python-dateutil
  ];

  meta = {
    homepage = "https://bitbucket.org/zzzeek/alembic";
    description = "Database migration tool for SQLAlchemy";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "alembic";
  };
}
