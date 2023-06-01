{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# extras: babel
, babel
, flask-babel

# extras: common
, bcrypt
, bleach
, flask-mailman
, qrcode

# extras: fsqla
, flask-sqlalchemy
, sqlalchemy
, sqlalchemy-utils

# extras: mfa
, cryptography
, phonenumbers

# propagates
, blinker
, email-validator
, flask
, flask-login
, flask_principal
, flask-wtf
, itsdangerous
, passlib

# tests
, argon2-cffi
, flask-mongoengine
, mongoengine
, mongomock
, peewee
, pony
, pytestCheckHook
, python-dateutil
, zxcvbn
}:

buildPythonPackage rec {
  pname = "flask-security-too";
  version = "5.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-Security-Too";
    inherit version;
    hash = "sha256-lZzm43m30y+2qjxNddFEeg9HDlQP9afq5VtuR25zaLc=";
  };

  propagatedBuildInputs = [
    blinker
    email-validator
    flask
    flask-login
    flask_principal
    flask-wtf
    itsdangerous
    passlib
  ];

  passthru.optional-dependencies = {
    babel = [
      babel
      flask-babel
    ];
    common = [
      bcrypt
      bleach
      flask-mailman
      qrcode
    ];
    fsqla = [
      flask-sqlalchemy
      sqlalchemy
      sqlalchemy-utils
    ];
    mfa = [
      cryptography
      phonenumbers
    ];
  };

  nativeCheckInputs = [
    argon2-cffi
    flask-mongoengine
    mongoengine
    mongomock
    peewee
    pony
    pytestCheckHook
    python-dateutil
    zxcvbn
  ]
  ++ passthru.optional-dependencies.babel
  ++ passthru.optional-dependencies.common
  ++ passthru.optional-dependencies.fsqla
  ++ passthru.optional-dependencies.mfa;


  pythonImportsCheck = [
    "flask_security"
  ];

  meta = with lib; {
    changelog = "https://github.com/Flask-Middleware/flask-security/blob/${version}/CHANGES.rst";
    homepage = "https://github.com/Flask-Middleware/flask-security";
    description = "Simple security for Flask apps (fork)";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
