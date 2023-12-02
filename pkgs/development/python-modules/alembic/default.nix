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
  version = "1.13.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-q0s7lNLh5fgeNL6Km3t1dfyd1TmPzLC+81HsmxSHJiM=";
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
  };
}
