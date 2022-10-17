{ lib
, buildPythonPackage
, pythonOlder
, nixosTests
, fetchPypi
, alembic
, aniso8601
, babel
, blinker
, cachetools
, click
, dnspython
, email-validator
, flask
, flask-babel
, flask-cors
, flask_mail
, flask_migrate
, flask-restful
, flask-talisman
, flask-wtf
, debts
, idna
, itsdangerous
, jinja2
, Mako
, markupsafe
, python-dateutil
, pytz
, requests
, sqlalchemy
, sqlalchemy-utils
, sqlalchemy-continuum
, sqlalchemy-i18n
, werkzeug
, wtforms
, psycopg2 # optional, for postgresql support
, flask-testing
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ihatemoney";
  version = "5.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-uQgZBbpqqbZYHpR+GwHWX0c7di2rVvEz0jPRY6+BkkQ=";
  };

  propagatedBuildInputs = [
    aniso8601
    babel
    blinker
    cachetools
    click
    debts
    dnspython
    email-validator
    flask
    flask_mail
    flask_migrate
    flask-wtf
    flask-babel
    flask-cors
    flask-restful
    flask-talisman
    idna
    itsdangerous
    jinja2
    Mako
    markupsafe
    psycopg2
    python-dateutil
    pytz
    requests
    sqlalchemy
    sqlalchemy-continuum
    werkzeug
    wtforms
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "cachetools>=4.1,<5" "cachetools>=4.1" \
      --replace "SQLAlchemy>=1.3.0,<1.4" "SQLAlchemy>=1.3.0,<1.5" \
      --replace "WTForms>=2.3.1,<3.1" "WTForms"
  '';

  checkInputs = [
    flask-testing
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ihatemoney"
  ];

  disabledTests = [
    # Requires running service
    "test_notifications"
    "test_invite"
    "test_access_other_projects"
    "test_authentication"
    "test_manage_bills"
    "test_member_delete_method"
    "test_membership"
    "test_bill_add_remove_add"
    "test_clear_ip_records"
    "test_disable_clear_no_new_records"
    "test_logs_for_common_actions"
    # Requires DNS resolution
    "test_invitation_email_failure"
  ];

  passthru.tests = {
    inherit (nixosTests.ihatemoney) ihatemoney-postgresql ihatemoney-sqlite;
  };

  meta = with lib; {
    description = "Shared budget manager web application";
    homepage = "https://ihatemoney.org";
    license = licenses.beerware;
    maintainers = with maintainers; [ symphorien ];
  };
}
