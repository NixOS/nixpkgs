{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,

  # dependencies
  mako,
  sqlalchemy,
  typing-extensions,

  # tests
  black,
  pytestCheckHook,
  pytest-xdist,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.19.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4PygUYEYx4rMST4xvLVALxkAV6r234tblc6UxHic9kg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    mako
    sqlalchemy
    typing-extensions
  ];

  pythonImportsCheck = [ "alembic" ];

  nativeCheckInputs = [
    black
    pytestCheckHook
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
