{ lib
, buildPythonPackage
, fetchPypi

# extras: babel
, babel
, flask-babel

# extras: common
, bcrypt
, bleach
, flask_mail

# extras: fsqla
, flask_sqlalchemy
, sqlalchemy
, sqlalchemy-utils

# extras: mfa
, cryptography
, phonenumbers
, pyqrcode

# propagates
, blinker
, email_validator
, flask
, flask_login
, flask_principal
, flask_wtf
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
, zxcvbn
}:

buildPythonPackage rec {
  pname = "flask-security-too";
  version = "4.1.4";

  src = fetchPypi {
    pname = "Flask-Security-Too";
    inherit version;
    sha256 = "sha256-j6My1CD+GY2InHlN0IXPcNqfq+ytdoDD3y+5s2o3WRI=";
  };

  propagatedBuildInputs = [
    blinker
    email_validator
    flask
    flask_login
    flask_principal
    flask_wtf
    itsdangerous
    passlib
  ];

  passthru.extras-require = {
    babel = [
      babel
      flask-babel
    ];
    common = [
      bcrypt
      bleach
      flask_mail
    ];
    fsqla = [
      flask_sqlalchemy
      sqlalchemy
      sqlalchemy-utils
    ];
    mfa = [
      cryptography
      phonenumbers
      pyqrcode
    ];
  };

  checkInputs = [
    argon2-cffi
    flask-mongoengine
    mongoengine
    mongomock
    peewee
    pony
    pytestCheckHook
    zxcvbn
  ]
  ++ passthru.extras-require.babel
  ++ passthru.extras-require.common
  ++ passthru.extras-require.fsqla
  ++ passthru.extras-require.mfa;


  pythonImportsCheck = [ "flask_security" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/Flask-Security-Too/";
    description = "Simple security for Flask apps (fork)";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
