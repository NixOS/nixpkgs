{ stdenv
, buildPythonPackage
, python
, fetchPypi
, flask
, flask-babelex
, flask_login
, flask_mail
, flask-mongoengine
, flask-peewee
, flask_principal
, flask_sqlalchemy
, flask_wtf
, pydocstyle
, pytest
, pytest-runner
, pytest-translations
, pytest-flakes
, pytestcov
, pytestpep8
, passlib
, pony
, mongoengine
, mock
, isort
, check-manifest
}:

buildPythonPackage rec {
  pname = "Flask-Security";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ck4ybpppka56cqv0s26h1jjq6sqvwmqfm85ylq9zy28b9gsl7fn";
  };

  buildInputs = [
    pydocstyle
    pytest
    pytest-runner
    pytest-translations
    pytest-flakes
    pytestcov
    pytestpep8
    flask-babelex
    flask_login
    flask-mongoengine
    flask_mail
    flask-peewee
    flask_principal
    flask_sqlalchemy
    flask_wtf
    passlib
    pony
    mongoengine
    mock
    isort
    check-manifest
  ];

  doCheck = false;

  propagatedBuildInputs = [
    flask
  ];

  meta = with stdenv.lib; {
    description = "Quick and simple security for Flask applications";
    longDescription = ''
      Flask-Security allows you to quickly add common security mechanisms to your Flask application. They include:

      1.  Session based authentication
      2.  Role management
      3.  Password hashing
      4.  Basic HTTP authentication
      5.  Token based authentication
      6.  Token based account activation (optional)
      7.  Token based password recovery / resetting (optional)
      8.  User registration (optional)
      9.  Login tracking (optional)
      10. JSON/Ajax Support
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ kuznero ];
    homepage = https://github.com/mattupstate/flask-security;
  };
}
