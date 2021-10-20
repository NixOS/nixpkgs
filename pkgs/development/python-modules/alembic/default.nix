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
  version = "1.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aea964d3dcc9c205b8759e4e9c1c3935ea3afeee259bffd7ed8414f8085140fb";
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
