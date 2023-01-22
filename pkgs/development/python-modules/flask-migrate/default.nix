{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, alembic
, flask
, flask_script
, flask-sqlalchemy
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "Flask-Migrate";
  version = "3.1.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
    repo = pname;
    rev = "v${version}";
    sha256 = "0zj7qpknvlhrh4fsp5sx4fwyx3sp41ynclka992zympm3xym9zyq";
  };

  propagatedBuildInputs = [
    alembic
    flask
    flask-sqlalchemy
  ];

  pythonImportsCheck = [
    "flask_migrate"
  ];

  nativeCheckInputs = [
    unittestCheckHook
    flask_script
  ];

  meta = with lib; {
    description = "SQLAlchemy database migrations for Flask applications using Alembic";
    homepage = "https://github.com/miguelgrinberg/Flask-Migrate";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
