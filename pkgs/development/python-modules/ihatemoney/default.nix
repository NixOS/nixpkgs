{ buildPythonPackage, lib, fetchFromGitHub, isPy27, nixosTests
, alembic
, aniso8601
, Babel
, blinker
, click
, dnspython
, email_validator
, flask
, flask-babel
, flask-cors
, flask_mail
, flask_migrate
, flask-restful
, flask_script
, flask_sqlalchemy
, flask_wtf
, idna
, itsdangerous
, jinja2
, Mako
, markupsafe
, mock
, python-dateutil
, pytz
, six
, sqlalchemy
, werkzeug
, wtforms
, psycopg2 # optional, for postgresql support
, flask_testing
}:

buildPythonPackage rec {
  pname = "ihatemoney";
  version = "4.1.5";

  src = fetchFromGitHub {
    owner = "spiral-project";
    repo = pname;
    rev = version;
    sha256 = "07lkc0rhj6f4fka4m1vimycjxa452d8wlclknviqz2566gnb998n";
  };

  postPatch = ''
    # remove patch release level pinning
    sed -i 's/==\([0-9]*\.[0-9]*\).*"/~=\1"/' setup.py
    # https://github.com/spiral-project/ihatemoney/issues/567
    sed -i 's/WTForms~=2.2/WTForms>=2.1,<2.3/' setup.py
  '';

  propagatedBuildInputs = [
    alembic
    aniso8601
    Babel
    blinker
    click
    dnspython
    email_validator
    flask
    flask-babel
    flask-cors
    flask_mail
    flask_migrate
    flask-restful
    flask_script
    flask_sqlalchemy
    flask_wtf
    idna
    itsdangerous
    jinja2
    Mako
    markupsafe
    python-dateutil
    pytz
    six
    sqlalchemy
    werkzeug
    wtforms
    psycopg2
  ];

  checkInputs = [
    flask_testing
  ] ++ lib.optionals isPy27 [ mock ];

  passthru.tests = {
    inherit (nixosTests) ihatemoney;
  };
  meta = with lib; {
    homepage = "https://ihatemoney.org";
    description = "A simple shared budget manager web application";
    platforms = platforms.linux;
    license = licenses.beerware;
    maintainers = [ maintainers.symphorien ];
  };
}


