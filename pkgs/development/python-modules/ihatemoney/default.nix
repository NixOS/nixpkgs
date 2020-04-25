{ buildPythonPackage, lib, fetchFromGitHub, isPy27, nixosTests, fetchpatch
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

  patches = [
    # fix migration on postgresql
    # remove on next release
    (fetchpatch {
      url = "https://github.com/spiral-project/ihatemoney/commit/6129191b26784b895e203fa3eafb89cee7d88b71.patch";
      sha256 = "0yc24gsih9x3pnh2mhj4v5i71x02dq93a9jd2r8b1limhcl4p1sw";
    })
  ];

  postPatch = ''
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


