{ buildPythonPackage
, lib
, isPy27
, nixosTests
, fetchPypi
, alembic
, aniso8601
, Babel
, blinker
, cachetools
, click
, dnspython
, email_validator
, flask
, flask-babel
, flask-cors
, flask_mail
, flask_migrate
, flask-restful
, flask_sqlalchemy
, flask-talisman
, flask_wtf
, debts
, idna
, itsdangerous
, jinja2
, Mako
, markupsafe
, python-dateutil
, pytz
, requests
, six
, sqlalchemy
, sqlalchemy-utils
, sqlalchemy-continuum
, sqlalchemy-i18n
, werkzeug
, wtforms
, psycopg2 # optional, for postgresql support
, flask_testing
, pytestCheckHook
, fetchpatch
}:

buildPythonPackage rec {
  pname = "ihatemoney";
  version = "5.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gsqba9qbs1dpmfys8qpiahy4pbn4khcc6mgmdnhssmkjsb94sx6";
  };

  disabled = isPy27;

  propagatedBuildInputs = [
    aniso8601
    Babel
    blinker
    cachetools
    click
    dnspython
    email_validator
    flask
    flask-babel
    flask-cors
    flask_mail
    flask_migrate
    flask-restful
    flask-talisman
    flask_wtf
    idna
    itsdangerous
    jinja2
    Mako
    markupsafe
    python-dateutil
    pytz
    requests
    six
    sqlalchemy-continuum
    werkzeug
    wtforms
    psycopg2
    debts
  ];

  patches = [
    # fix build with wtforms 3. remove with next release
    (fetchpatch {
      url = "https://github.com/spiral-project/ihatemoney/commit/40ce32d9fa58a60d26a4d0df547b8deb709c330d.patch";
      sha256 = "sha256-2ewOu21qhq/AOZaE9qrF5J6HH0h6ohFgjDb+BYjJnuQ=";
      excludes = [ "setup.cfg" ];
    })
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "cachetools>=4.1,<5" "cachetools>=4.1" \
      --replace "Flask-WTF>=0.14.3,<1" "Flask-WTF>=0.14.3,<2" \
      --replace "SQLAlchemy>=1.3.0,<1.4" "SQLAlchemy>=1.3.0,<1.5" \
      --replace "WTForms>=2.3.1,<2.4" "WTForms"
  '';

  checkInputs = [
    flask_testing
    pytestCheckHook
  ];

  pythonImportsCheck = [ "ihatemoney" ];

  disabledTests = [
    "test_notifications"  # requires running service.
    "test_invite"         # requires running service.
    "test_invitation_email_failure" # requires dns resolution
  ];

  passthru.tests = {
    inherit (nixosTests.ihatemoney) ihatemoney-postgresql ihatemoney-sqlite;
  };

  meta = with lib; {
    homepage = "https://ihatemoney.org";
    description = "A simple shared budget manager web application";
    license = licenses.beerware;
    maintainers = [ maintainers.symphorien ];
  };
}
