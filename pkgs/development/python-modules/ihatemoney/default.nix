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
, debts
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
, sqlalchemy-continuum
, werkzeug
, wtforms
, psycopg2 # optional, for postgresql support
, flask_testing
}:

buildPythonPackage rec {
  pname = "ihatemoney";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "spiral-project";
    repo = pname;
    rev = version;
    sha256 = "0d4vc6m0jkwlz9ly0hcjghccydvqbldh2jb8yzf94jrgkd5fd7k1";
  };

  patchPhase = ''
    # remove draconian pinning
    sed -i 's/==.*$//' setup.cfg
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
    sqlalchemy-continuum
    werkzeug
    wtforms
    psycopg2
    debts
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


