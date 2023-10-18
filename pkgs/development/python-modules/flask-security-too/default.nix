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
, webauthn

# propagates
, blinker
, email-validator
, flask
, flask-login
, flask-principal
, flask-wtf
, itsdangerous
, passlib
, importlib-resources

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
  version = "5.3.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "Flask-Security-Too";
    inherit version;
    hash = "sha256-Ha/gDGEc44Eef+Fobs13UJOIBqHsPFongYXzGViJXTw=";
  };

  postPatch = ''
    # This should be removed after updating to version 5.3.0.
    sed -i '/filterwarnings =/a ignore:pkg_resources is deprecated:DeprecationWarning' pytest.ini
  '';

  propagatedBuildInputs = [
    blinker
    email-validator
    flask
    flask-login
    flask-principal
    flask-wtf
    itsdangerous
    passlib
    importlib-resources
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
      webauthn
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
    # needs a /etc/resolv.conf present
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
