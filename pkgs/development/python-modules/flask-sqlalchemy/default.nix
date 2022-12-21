{ lib
, buildPythonPackage
, fetchPypi
, pdm-pep517
, flask
, mock
, sqlalchemy
, pytestCheckHook
, nix-update-script
}:

buildPythonPackage rec {
  pname = "Flask-SQLAlchemy";
  version = "3.0.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FhmfWz3ftp4N8vUq5Mdq7b/sgjRiNJ2rshobLgorZek=";
  };

  nativeBuildInputs = [
    pdm-pep517
  ];

  propagatedBuildInputs = [
    flask
    sqlalchemy
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  disabledTests = [
    # flaky
    "test_session_scoping_changing"
    # https://github.com/pallets-eco/flask-sqlalchemy/issues/1084
    "test_persist_selectable"
  ];

  passthru.updateScript = nix-update-script {
    attrPath = "python3Packages.flask-sqlalchemy";
  };

  meta = with lib; {
    description = "SQLAlchemy extension for Flask";
    homepage = "http://flask-sqlalchemy.pocoo.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ gerschtli ];
  };
}
