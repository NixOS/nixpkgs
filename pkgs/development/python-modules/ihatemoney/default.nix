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
}:

# ihatemoney is not really a library. It will only ever be imported
# by the interpreter of uwsgi. So overrides for its depencies are fine.
let
  # sqlalchemy-continuum requires sqlalchemy < 1.4
  pinned_sqlalchemy = sqlalchemy.overridePythonAttrs (
    old: rec {
      pname = "SQLAlchemy";
      version = "1.3.24";

      src = fetchPypi {
        inherit pname version;
        sha256 = "06bmxzssc66cblk1hamskyv5q3xf1nh1py3vi6dka4lkpxy7gfzb";
      };
    }
  );
in

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
    (
      flask_migrate.override {
        flask_sqlalchemy = flask_sqlalchemy.override {
          sqlalchemy = pinned_sqlalchemy;
        };
        alembic = alembic.override {
          sqlalchemy = pinned_sqlalchemy;
        };
      }
    )
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
    (
      (
        sqlalchemy-continuum.override {
          sqlalchemy = pinned_sqlalchemy;
          sqlalchemy-utils = sqlalchemy-utils.override {
            sqlalchemy = pinned_sqlalchemy;
          };
          sqlalchemy-i18n = sqlalchemy-i18n.override {
            sqlalchemy = pinned_sqlalchemy;
            sqlalchemy-utils = sqlalchemy-utils.override {
              sqlalchemy = pinned_sqlalchemy;
            };
          };
          flask_sqlalchemy = flask_sqlalchemy.override {
            sqlalchemy = pinned_sqlalchemy;
          };
        }
      ).overridePythonAttrs (
        old: {
          doCheck = false;
        }
      )
    )
    werkzeug
    wtforms
    psycopg2
    debts
  ];

  checkInputs = [
    flask_testing
    pytestCheckHook
  ];

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
