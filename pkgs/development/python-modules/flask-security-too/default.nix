{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, fetchpatch

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
  version = "5.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-Security-Too";
    inherit version;
    hash = "sha256-nSo7fdY9tiE7PnhosXh1eBfVa5l6a43XNvp6vKvrq5Y=";
  };

  patches = [
    # Fixed issues related to upcomming flask-sqlalchemy 3.0.0 release
    (fetchpatch {
      name = "fix-sqlalchemy.patch";
      url = "https://github.com/Flask-Middleware/flask-security/commit/9632a0eab5d3be4280c185e7e934a57fc24057a2.patch";
      hash = "sha256-GOFWNhB83KC9R66ZASyag33Paqv+7njGD+oRlhjxZnk=";
    })
    # Test fixes for Flask-SQLAlchemy 3.0
    (fetchpatch {
      name = "test-fixes-for-sqlalchemy.patch";
      url = "https://github.com/Flask-Middleware/flask-security/commit/a086bf6886b483266d7c7df5742774dd1d095e7f.patch";
      hash = "sha256-bGJWaHbJfMytfW4OmCHMn+Bk95sMUKFPQpNN67LLoRY=";
      excludes = [ ".pre-commit-config.yaml" ];
    })
    # Changes for sqlalchemy 2.0.0 compatibility
    (fetchpatch {
      name = "fix-backwards-compatibility-for-sqlalchemy.patch";
      url = "https://github.com/Flask-Middleware/flask-security/commit/4fcaabd90fcf3329c1f76f84fb877b35f8573ed3.patch";
      hash = "sha256-vhdvHV8KFt6ItctoUExNjEdrhVad0Pt9Atd3lLMyUlM=";
    })
  ];

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
