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
  version = "1.7.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-fDKGlKLmjwPulx5jw72IWEZHA3OltTLPLJ8WAcQTsVM=";
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
    "--numprocesses" "$NIX_BUILD_CORES"
  ];

  meta = with lib; {
    homepage = "https://bitbucket.org/zzzeek/alembic";
    description = "A database migration tool for SQLAlchemy";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
