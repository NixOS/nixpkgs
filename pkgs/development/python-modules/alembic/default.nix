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
  version = "1.16.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-76tq2g3Q+uLJIGCADgv1wdwmrxWhDgL7S6v/FktHJeI=";
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

  meta = with lib; {
    homepage = "https://bitbucket.org/zzzeek/alembic";
    description = "Database migration tool for SQLAlchemy";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "alembic";
  };
}
