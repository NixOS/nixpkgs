{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  mock,
  flit-core,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "flask-sqlalchemy";
  version = "3.1.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "flask_sqlalchemy";
    inherit version;
    hash = "sha256-5LaLuIGALdoafYeLL8hMBtHuV/tAuHTT3Jfav6NrgxI=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    flask
    sqlalchemy
  ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
  ];

  doCheck = pythonOlder "3.13"; # https://github.com/pallets-eco/flask-sqlalchemy/issues/1379

  disabledTests = [
    # flaky
    "test_session_scoping_changing"
    # https://github.com/pallets-eco/flask-sqlalchemy/issues/1378
    "test_explicit_table"
  ];

  pytestFlags = lib.optionals (pythonAtLeast "3.12") [
    # datetime.datetime.utcnow() is deprecated and scheduled for removal in a future version.
    "-Wignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "flask_sqlalchemy" ];

  meta = with lib; {
    description = "SQLAlchemy extension for Flask";
    homepage = "http://flask-sqlalchemy.pocoo.org/";
    changelog = "https://github.com/pallets-eco/flask-sqlalchemy/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
