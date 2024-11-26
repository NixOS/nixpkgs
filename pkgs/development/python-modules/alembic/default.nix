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
  version = "1.13.3";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IDUDEXQVVh4gOqFFQXQGQ6YR9kFRfwIJ/K5j6foJ8aI=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
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

  meta = with lib; {
    homepage = "https://bitbucket.org/zzzeek/alembic";
    description = "Database migration tool for SQLAlchemy";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "alembic";
  };
}
