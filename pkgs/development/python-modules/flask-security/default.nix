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
  pony,
  pytestCheckHook,
  requests,
  zxcvbn,
}:

buildPythonPackage rec {
  pname = "flask-security";
  version = "5.5.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pallets-eco";
    repo = "flask-security";
    rev = "refs/tags/${version}";
    hash = "sha256-RGRwgrDFe+0v8NYyajMikdoi1DQf1I+B5y8KJyF+cZs=";
  };

  build-system = [ flit-core ];

  # flask-login>=0.6.2 not satisfied by version 0.7.0.dev0
  pythonRelaxDeps = [ "flask-login" ];

  dependencies = [
    email-validator
    flask
    flask-login
    flask-principal
    flask-wtf
    markupsafe
    passlib
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

  nativeCheckInputs =
    [
      authlib
      flask-sqlalchemy-lite
      freezegun
      mongoengine
      mongomock
      peewee
      pony
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

  meta = with lib; {
    changelog = "https://github.com/pallets-eco/flask-security/blob/${version}/CHANGES.rst";
    homepage = "https://github.com/pallets-eco/flask-security";
    description = "Quickly add security features to your Flask application";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
