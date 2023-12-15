{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, mako
, python-dateutil
, sqlalchemy
, importlib-metadata
, importlib-resources
, pytest-xdist
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jnZFwy5PIAZ15p8HRUFTNetZo2Y/X+tIer+gswxFiIs=";
  };

  propagatedBuildInputs = [
    mako
    python-dateutil
    sqlalchemy
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  pythonImportsCheck = [
    "alembic"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  meta = with lib; {
    homepage = "https://bitbucket.org/zzzeek/alembic";
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "alembic";
  };
}
