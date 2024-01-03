{
  lib,
  python3,
  fetchFromGitHub,
  react-jsx-i18n,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "indico";
  version = "3.2.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "indico";
    repo = "indico";
    rev = "v${version}";
    hash = "sha256-icgf+gD+Xcubq0BOHIWPmCxzmwEcuCAYHybuPS/1LdU=";
  };

  patches = [ ./setup.patch ];

  pythonRelaxDeps = true;

  nativeBuildInputs = [
    python3.pkgs.pythonRelaxDepsHook
    python3.pkgs.setuptools
    python3.pkgs.wheel
    react-jsx-i18n
  ];

  propagatedBuildInputs = with python3.pkgs; [
    alembic
    amqp
    asttokens
    async-timeout
    attrs
    authlib
    babel
    backcall
    bcrypt
    billiard
    bleach
    blinker
    cachelib
    captcha
    celery
    certifi
    cffi
    charset-normalizer
    click
    click-didyoumean
    click-plugins
    click-repl
    colorclass
    cryptography
    decorator
    deprecated
    distro
    dnspython
    email-validator
    executing
    feedgen
    flask
    flask-babel
    flask-caching
    flask-limiter
    flask-marshmallow
    flask-migrate
    flask-multipass
    flask-pluginengine
    flask-sqlalchemy
    flask-webpackext
    flask-wtf
    greenlet
    hiredis
    html2text
    html5lib
    icalendar
    idna
    importlib-metadata
    importlib-resources
    indico-fonts
    ipython
    itsdangerous
    jedi
    jinja2
    jsonschema
    kombu
    limits
    lxml
    mako
    markdown
    markdown-it-py
    markupsafe
    marshmallow
    marshmallow-dataclass
    marshmallow-enum
    marshmallow-oneofschema
    marshmallow-sqlalchemy
    matplotlib-inline
    mdurl
    mypy-extensions
    node-semver
    ordered-set
    packaging
    parso
    pexpect
    pickleshare
    pillow
    prompt-toolkit
    psycopg2
    ptyprocess
    pure-eval
    pycountry
    pycparser
    pygments
    pynpm
    pypdf
    pypng
    pyrsistent
    python-dateutil
    pytz
    pywebpack
    pyyaml
    qrcode
    redis
    reportlab
    requests
    rich
    sentry-sdk
    simplejson
    six
    speaklater
    sqlalchemy
    stack-data
    terminaltables
    tinycss2
    traitlets
    translitcodec
    typing-extensions
    typing-inspect
    tzdata
    ua-parser
    urllib3
    vine
    wcwidth
    webargs
    webencodings
    werkzeug
    wrapt
    wtforms
    wtforms-dateutil
    wtforms-sqlalchemy
    xlsxwriter
    zipp
  ];

  pythonImportsCheck = [ "indico" ];

  meta = with lib; {
    description = "Indico - A feature-rich event management system, made @ CERN, the place where the Web was born";
    homepage = "https://github.com/indico/indico";
    changelog = "https://github.com/indico/indico/blob/${src.rev}/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ thubrecht ];
    mainProgram = "indico";
  };
}
