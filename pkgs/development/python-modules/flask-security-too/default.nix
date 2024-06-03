{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,

  # extras: babel
  babel,
  flask-babel,

  # extras: common
  bcrypt,
  bleach,
  flask-mailman,

  # extras: fsqla
  flask-sqlalchemy,
  sqlalchemy,
  sqlalchemy-utils,

  # extras: mfa
  cryptography,
  phonenumbers,
  webauthn,
  qrcode,

  # propagates
  email-validator,
  flask,
  flask-login,
  flask-principal,
  flask-wtf,
  passlib,
  importlib-resources,
  wtforms,

  # tests
  argon2-cffi,
  freezegun,
  mongoengine,
  mongomock,
  peewee,
  pony,
  pytestCheckHook,
  zxcvbn,
}:

buildPythonPackage rec {
  pname = "flask-security-too";
  version = "5.4.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-Security-Too";
    inherit version;
    hash = "sha256-YrGTl+jXGo1MuNwNRAnMehSXmCVJAwOWlgruUYdV5YM=";
  };

  nativeBuildInputs = [ setuptools ];

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

  nativeCheckInputs =
    [
      argon2-cffi
      freezegun
      mongoengine
      mongomock
      peewee
      pony
      pytestCheckHook
      zxcvbn
      freezegun
    ]
    ++ passthru.optional-dependencies.babel
    ++ passthru.optional-dependencies.common
    ++ passthru.optional-dependencies.fsqla
    ++ passthru.optional-dependencies.mfa;

  disabledTests = [
    # needs /etc/resolv.conf
    "test_login_email_whatever"
  ];

  pythonImportsCheck = [ "flask_security" ];

  meta = with lib; {
    changelog = "https://github.com/Flask-Middleware/flask-security/blob/${version}/CHANGES.rst";
    homepage = "https://github.com/Flask-Middleware/flask-security";
    description = "Simple security for Flask apps (fork)";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
