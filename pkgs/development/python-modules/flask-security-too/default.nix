{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, fetchpatch

# extras: babel
, babel
, flask-babel

# extras: common
, bcrypt
, bleach
, flask-mailman

# extras: fsqla
, flask-sqlalchemy
, sqlalchemy
, sqlalchemy-utils

# extras: mfa
, cryptography
, phonenumbers
, webauthn
, qrcode

# propagates
, email-validator
, flask
, flask-login
, flask-principal
, flask-wtf
, passlib
, importlib-resources
, wtforms

# tests
, argon2-cffi
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
  version = "5.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-Security-Too";
    inherit version;
    hash = "sha256-we2TquU28qP/ir4eE67J0Nlft/8IL8w7Ny3ypSE5cNk=";
  };

  patches = [
    # https://github.com/Flask-Middleware/flask-security/pull/901
    (fetchpatch {
      name = "fixes-for-py_webauthn-2.0.patch";
      url = "https://github.com/Flask-Middleware/flask-security/commit/5725f7021343567ec0b25c890e859f4e84c93ba6.patch";
      hash = "sha256-4EgwT4zRj0mh4ZaoZFz7H5KeiZ9zs+BY4siYm8DwMfU=";
      excludes = [ "CHANGES.rst" ];
    })
  ];

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    email-validator
    flask
    flask-login
    flask-principal
    flask-wtf
    passlib
    importlib-resources
    wtforms
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
    ];
    fsqla = [
      flask-sqlalchemy
      sqlalchemy
      sqlalchemy-utils
    ];
    mfa = [
      cryptography
      phonenumbers
      webauthn
      qrcode
    ];
  };

  nativeCheckInputs = [
    argon2-cffi
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


  disabledTests = [
    # needs /etc/resolv.conf
    "test_login_email_whatever"
  ];

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
