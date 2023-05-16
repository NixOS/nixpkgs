{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, alembic
, flask
<<<<<<< HEAD
, flask-script
=======
, flask_script
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, flask-sqlalchemy
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
<<<<<<< HEAD
  pname = "flask-migrate";
=======
  pname = "Flask-Migrate";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  version = "4.0.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "miguelgrinberg";
<<<<<<< HEAD
    repo = "Flask-Migrate";
=======
    repo = pname;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    rev = "v${version}";
    hash = "sha256-x52LGYvXuTUCP9dR3FP7a/xNRWyCAV1sReDAYJbYDvE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    alembic
    flask
    flask-sqlalchemy
  ];

  pythonImportsCheck = [
    "flask_migrate"
  ];

  nativeCheckInputs = [
    pytestCheckHook
<<<<<<< HEAD
    flask-script
=======
    flask_script
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  meta = with lib; {
    description = "SQLAlchemy database migrations for Flask applications using Alembic";
    homepage = "https://github.com/miguelgrinberg/Flask-Migrate";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
