{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,

  # extras: babel
  babel,
  flask-babel,

  # extras: common
  argon2-cffi,
  bcrypt,
  bleach,
  flask-mail,

  # extras: fsqla
  flask-sqlalchemy,
  sqlalchemy,
  sqlalchemy-utils,

  # extras: mfa
  cryptography,
  phonenumberslite,
  webauthn,
  qrcode,

  # propagates
  email-validator,
  flask,
  flask-login,
  flask-principal,
  flask-wtf,
  libpass,
  markupsafe,
  passlib,
  importlib-resources,
  wtforms,

  # tests
  authlib,
  flask-sqlalchemy-lite,
  freezegun,
  mongoengine,
  mongomock,
  peewee,
  pytestCheckHook,
  requests,
  zxcvbn,
}:

buildPythonPackage rec {
  pname = "flask-security";
  version = "5.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-security";
    tag = version;
    hash = "sha256-XxlSkD9mWNcaHi9WvNtOayvFCOZMOznnLzdXvjxfKP8=";
  };

  build-system = [ flit-core ];

  dependencies = [
    email-validator
    flask
    flask-login
    flask-principal
    flask-wtf
    markupsafe
    libpass
    wtforms
  ];

  optional-dependencies = {
    babel = [
      babel
      flask-babel
    ];
    common = [
      argon2-cffi
      bcrypt
      bleach
      flask-mail
    ];
    fsqla = [
      flask-sqlalchemy
      sqlalchemy
    ];
    mfa = [
      cryptography
      phonenumberslite
      webauthn
      qrcode
    ];
  };

  nativeCheckInputs = [
    authlib
    flask-sqlalchemy-lite
    freezegun
    mongoengine
    mongomock
    peewee
    pytestCheckHook
    requests
    zxcvbn
  ]
  ++ optional-dependencies.babel
  ++ optional-dependencies.common
  ++ optional-dependencies.fsqla
  ++ optional-dependencies.mfa;

  preCheck = ''
    pybabel compile --domain flask_security -d flask_security/translations
  '';

  disabledTests = [
    # needs /etc/resolv.conf
    "test_login_email_whatever"
  ];

  pythonImportsCheck = [ "flask_security" ];

  meta = {
    changelog = "https://github.com/pallets-eco/flask-security/blob/${src.tag}/CHANGES.rst";
    homepage = "https://github.com/pallets-eco/flask-security";
    description = "Quickly add security features to your Flask application";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gador ];
  };
}
