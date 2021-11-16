{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, Mako
, python-dateutil
, sqlalchemy
, importlib-metadata
, importlib-resources
, pytest-xdist
, pytestCheckHook

}:

buildPythonPackage rec {
  pname = "alembic";
  version = "1.7.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9d33f3ff1488c4bfab1e1a6dfebbf085e8a8e1a3e047a43ad29ad1f67f012a1d";
  };

  propagatedBuildInputs = [
    Mako
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

  checkInputs = [
    pytestCheckHook
    pytest-xdist
  ];

  pytestFlagsArray = [
    "--numprocesses" "auto"
  ];

  meta = with lib; {
    homepage = "https://bitbucket.org/zzzeek/alembic";
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
