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
  version = "1.9.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TTvTLs27e7+0ip/p5tb9aoMaG1nQPibikiECNzc+fbU=";
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
