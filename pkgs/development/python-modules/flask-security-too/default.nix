{ lib
, buildPythonPackage
, fetchPypi

# extras: babel
, Babel
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
  version = "4.1.3";

  src = fetchPypi {
    pname = "Flask-Security-Too";
    inherit version;
    sha256 = "sha256-mW2NKGeJpyR4Ri7m+KE3ElSg3E+P7qbzNTTCo3cskc8=";
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
      Babel
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

  disabledTests = [
    # flask 2.1.0 incompatibilities https://github.com/Flask-Middleware/flask-security/issues/594
    "test_admin_setup_reset"
    "test_authn_freshness"
    "test_authn_freshness_nc"
    "test_bad_sender"
    "test_change_invalidates_auth_token"
    "test_change_invalidates_session"
    "test_default_authn_bp"
    "test_default_unauthn"
    "test_default_unauthn_bp"
    "test_email_not_identity"
    "test_next"
    "test_post_security_with_application_root"
    "test_post_security_with_application_root_and_views"
    "test_recover_invalidates_session"
    "test_two_factor_flag"
    "test_unauthorized_access_with_referrer"
    "test_verify"
    "test_verify_link"
    "test_view_configuration"
  ];

  pythonImportsCheck = [ "flask_security" ];

  meta = with lib; {
    homepage = "https://pypi.org/project/Flask-Security-Too/";
    description = "Simple security for Flask apps (fork)";
    license = licenses.mit;
    maintainers = with maintainers; [ gador ];
  };
}
