{ lib
, buildPythonPackage
, fetchPypi
, flask
, blinker
, setuptools
, itsdangerous
, flask_principal
, passlib
, email_validator
, flask_wtf
, flask_login
, pytestCheckHook
, flask_mail
, sqlalchemy
, flask_sqlalchemy
, flask-mongoengine
, peewee
, pony
, zxcvbn
, mongoengine
, cryptography
, pyqrcode
, phonenumbers
, bleach
, mongomock
}:

buildPythonPackage rec {
  pname = "flask-security-too";
  version = "4.1.2";

  src = fetchPypi {
    pname = "Flask-Security-Too";
    inherit version;
    sha256 = "16ws5n08vm7wsa2f7lrkxvc7jl3ah1xfylhhyzb4vvqmlk7x9hw8";
  };

  propagatedBuildInputs = [
    flask
    flask_login
    flask_principal
    flask_wtf
    email_validator
    itsdangerous
    passlib
    blinker
    setuptools
  ];

  checkInputs = [
    pytestCheckHook
    flask_mail
    sqlalchemy
    flask_sqlalchemy
    flask-mongoengine
    peewee
    pony
    zxcvbn
    mongoengine
    cryptography
    pyqrcode
    phonenumbers
    bleach
    mongomock
  ];

  pythonImportsCheck = [ "flask_security" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/Flask-Security-Too/";
    description = "Simple security for Flask apps (fork)";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
