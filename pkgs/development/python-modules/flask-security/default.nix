{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  flit-core,

  # extras: babel
  babel,
  flask-babel,

  # extras: common
  argon2-cffi,
  bcrypt,
  bleach,
  flask-mailman,

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
  version = "5.6.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-security";
    tag = version;
    hash = "sha256-mEl98Yp4USKu+z636yAb5p5qPBzcdQraZ/XaPbDoGWU=";
  };

  build-system = [ flit-core ];

  dependencies = [
    email-validator
    flask
    flask-login
    flask-principal
    flask-wtf
    markupsafe
    (if pythonOlder "3.12" then passlib else libpass)
    importlib-resources
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
      flask-mailman
    ];
    fsqla = [
      flask-sqlalchemy
      sqlalchemy
      sqlalchemy-utils
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
