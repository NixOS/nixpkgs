{ buildPythonPackage, lib, fetchFromGitHub, isPy27, nixosTests, fetchpatch, fetchPypi
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

# ihatemoney is not really a library. It will only ever be imported
# by the interpreter of uwsgi. So overrides for its depencies are fine.
let
  # https://github.com/spiral-project/ihatemoney/issues/567
  pinned_wtforms = wtforms.overridePythonAttrs (old: rec {
    pname = "WTForms";
    version = "2.2.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "0q9vkcq6jnnn618h27lx9sas6s9qlg2mv8ja6dn0hy38gwzarnqc";
    };
  });
  pinned_flask_wtf = flask_wtf.override { wtforms = pinned_wtforms; };
in

buildPythonPackage rec {
  pname = "ihatemoney";
  version = "4.2";

  src = fetchFromGitHub {
    owner = "spiral-project";
    repo = pname;
    rev = version;
    sha256 = "0d4vc6m0jkwlz9ly0hcjghccydvqbldh2jb8yzf94jrgkd5fd7k1";
  };

  disabled = isPy27;

  patches = [
    # fix migration on postgresql
    # remove on next release
    (fetchpatch {
      url = "https://github.com/spiral-project/ihatemoney/commit/6129191b26784b895e203fa3eafb89cee7d88b71.patch";
      sha256 = "0yc24gsih9x3pnh2mhj4v5i71x02dq93a9jd2r8b1limhcl4p1sw";
    })
    (fetchpatch {
      name = "CVE-2020-15120.patch";
      url = "https://github.com/spiral-project/ihatemoney/commit/8d77cf5d5646e1d2d8ded13f0660638f57e98471.patch";
      sha256 = "0y855sk3qsbpq7slj876k2ifa1lccc2dccag98pkyaadpz5gbabv";
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
    pinned_flask_wtf
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
    pinned_wtforms
    psycopg2
    debts
  ];

  checkInputs = [
    flask_testing
  ];

  passthru.tests = {
    inherit (nixosTests) ihatemoney;
  };
  meta = with lib; {
    homepage = "https://ihatemoney.org";
    description = "A simple shared budget manager web application";
    license = licenses.beerware;
    maintainers = [ maintainers.symphorien ];
  };
}


