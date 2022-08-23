{ lib
, stdenv
, python
, buildPythonPackage
, fetchFromGitHub
, alembic
, argcomplete
, attrs
, blinker
, cached-property
, cattrs
, clickclick
, colorlog
, croniter
, cryptography
, dataclasses
, dill
, flask
, flask_login
, flask-wtf
, flask-appbuilder
, flask-caching
, GitPython
, graphviz
, gunicorn
, httpx
, iso8601
, importlib-resources
, importlib-metadata
, inflection
, itsdangerous
, jinja2
, jsonschema
, lazy-object-proxy
, lockfile
, markdown
, markupsafe
, marshmallow-oneofschema
, numpy
, openapi-spec-validator
, pandas
, pendulum
, psutil
, pygments
, pyjwt
, python-daemon
, python-dateutil
, python-nvd3
, python-slugify
, python3-openid
, pythonOlder
, pyyaml
, rich
, setproctitle
, sqlalchemy
, sqlalchemy-jsonfield
, swagger-ui-bundle
, tabulate
, tenacity
, termcolor
, unicodecsv
, werkzeug
, pytestCheckHook
, freezegun
, mkYarnPackage
}:
let
  version = "2.3.3";

  airflow-src = fetchFromGitHub rec {
    owner = "apache";
    repo = "airflow";
    rev = "refs/tags/${version}";
    sha256 = "sha256-N+6ljfSo6+UvSAnvDav6G0S49JZ1VJwxmaiKPV3/DjA=";
  };

  # airflow bundles a web interface, which is built using webpack by an undocumented shell script in airflow's source tree.
  # This replicates this shell script, fixing bugs in yarn.lock and package.json

  airflow-frontend = mkYarnPackage {
    name = "airflow-frontend";

    src = "${airflow-src}/airflow/www";
    packageJSON = ./package.json;
    yarnLock = ./yarn.lock;
    yarnNix = ./yarn.nix;

    distPhase = "true";

    configurePhase = ''
      cp -r $node_modules node_modules
    '';

    buildPhase = ''
      yarn --offline build
      find package.json yarn.lock static/css static/js -type f | sort | xargs md5sum > static/dist/sum.md5
    '';

    installPhase = ''
      mkdir -p $out/static/
      cp -r static/dist $out/static
    '';
  };

in
buildPythonPackage rec {
  pname = "apache-airflow";
  inherit version;
  src = airflow-src;

  disabled = pythonOlder "3.6";

  propagatedBuildInputs = [
    alembic
    argcomplete
    attrs
    blinker
    cached-property
    cattrs
    clickclick
    colorlog
    croniter
    cryptography
    dill
    flask
    flask-appbuilder
    flask-caching
    flask_login
    flask-wtf
    GitPython
    graphviz
    gunicorn
    httpx
    iso8601
    importlib-resources
    inflection
    itsdangerous
    jinja2
    jsonschema
    lazy-object-proxy
    lockfile
    markdown
    markupsafe
    marshmallow-oneofschema
    numpy
    openapi-spec-validator
    pandas
    pendulum
    psutil
    pygments
    pyjwt
    python-daemon
    python-dateutil
    python-nvd3
    python-slugify
    python3-openid
    pyyaml
    rich
    setproctitle
    sqlalchemy
    sqlalchemy-jsonfield
    swagger-ui-bundle
    tabulate
    tenacity
    termcolor
    unicodecsv
    werkzeug
  ] ++ lib.optionals (pythonOlder "3.7") [
    dataclasses
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-metadata
  ];

  buildInputs = [
    airflow-frontend
  ];

  checkInputs = [
    freezegun
    pytestCheckHook
  ];

  INSTALL_PROVIDERS_FROM_SOURCES = "true";

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "attrs>=20.0, <21.0" "attrs" \
      --replace "cattrs~=1.1, <1.7.0" "cattrs" \
      --replace "colorlog>=4.0.2, <6.0" "colorlog" \
      --replace "croniter>=0.3.17, <1.1" "croniter" \
      --replace "docutils<0.17" "docutils" \
      --replace "flask-login>=0.3, <0.5" "flask-login" \
      --replace "flask-wtf>=0.14.3, <0.15" "flask-wtf" \
      --replace "flask>=1.1.0, <2.0" "flask" \
      --replace "importlib_resources~=1.4" "importlib_resources" \
      --replace "itsdangerous>=1.1.0, <2.0" "itsdangerous" \
      --replace "markupsafe>=1.1.1, <2.0" "markupsafe" \
      --replace "pyjwt<2" "pyjwt" \
      --replace "python-slugify>=3.0.0,<5.0" "python-slugify" \
      --replace "sqlalchemy_jsonfield~=1.0" "sqlalchemy-jsonfield" \
      --replace "tenacity~=6.2.0" "tenacity" \
      --replace "werkzeug~=1.0, >=1.0.1" "werkzeug"

    substituteInPlace tests/core/test_core.py \
      --replace "/bin/bash" "${stdenv.shell}"
  '' + lib.optionalString stdenv.isDarwin ''
    # Fix failing test on Hydra
    substituteInPlace airflow/utils/db.py \
      --replace "/tmp/sqlite_default.db" "$TMPDIR/sqlite_default.db"
  '';

  # allow for gunicorn processes to have access to Python packages
  makeWrapperArgs = [
    "--prefix PYTHONPATH : $PYTHONPATH"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export AIRFLOW_HOME=$HOME
    export AIRFLOW__CORE__UNIT_TEST_MODE=True
    export AIRFLOW_DB="$HOME/airflow.db"
    export PATH=$PATH:$out/bin

    airflow version
    airflow db init
    airflow db reset -y
  '';

  pytestFlagsArray = [
    "tests/core/test_core.py"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "bash_operator_kill" # psutil.AccessDenied
  ];

  postInstall = ''
    cp -rv ${airflow-frontend}/static/dist $out/lib/${python.libPrefix}/site-packages/airflow/www/static
  '';

  meta = with lib; {
    description = "Programmatically author, schedule and monitor data pipelines";
    homepage = "https://airflow.apache.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple costrouc ingenieroariel ];
    # requires extremely outdated versions of multiple dependencies
    broken = true;
  };
}
