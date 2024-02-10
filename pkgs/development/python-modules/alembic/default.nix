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
  version = "1.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q0s7lNLh5fgeNL6Km3t1dfyd1TmPzLC+81HsmxSHJiM=";
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
