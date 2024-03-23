{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# build-system
, setuptools

# dependencies
, importlib-metadata
, importlib-resources
, mako
, sqlalchemy
, typing-extensions

# tests
, pytestCheckHook
, pytest-xdist
, python-dateutil
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-STLIVYv2jy7pK5u8uCGGccYnBk1bCJOUN69td9wF5ZU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    mako
    sqlalchemy
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
    importlib-metadata
  ];

  pythonImportsCheck = [
    "alembic"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
    python-dateutil
  ];

  meta = with lib; {
    homepage = "https://bitbucket.org/zzzeek/alembic";
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "alembic";
  };
}
