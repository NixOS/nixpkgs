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
  version = "1.17.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-u+l1FwXF4PFId/AtRsU9EIheN349kO2oEKAW+bqhno4=";
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
