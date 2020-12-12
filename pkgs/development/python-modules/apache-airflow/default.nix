{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, alembic
, argcomplete
, cached-property
, cattrs
, configparser
, colorlog
, croniter
, dill
, email_validator
, flask
, flask-appbuilder
, flask-admin
, flask-caching
, flask_login
, flask-swagger
, flask_wtf
, flask-bcrypt
, funcsigs
, future
, GitPython
, graphviz
, gunicorn
, importlib-metadata
, importlib-resources
, iso8601
, json-merge-patch
, jinja2
, ldap3
, lxml
, lazy-object-proxy
, markdown
, marshmallow-sqlalchemy
, pandas
, pendulum
, psutil
, pygments
, python-daemon
, python-dateutil
, python-nvd3
, python-slugify
, requests
, setproctitle
, sqlalchemy
, sqlalchemy-jsonfield
, tabulate
, tenacity
, termcolor
, thrift
, typing-extensions
, tzlocal
, unicodecsv
, werkzeug
, zope_deprecation
# Test inputs
, pytestCheckHook
, azure-common
, freezegun
, hdfs
, hvac
, parameterized
, psycopg2
, procps
, sentry-sdk
, snakebite
}:

buildPythonPackage rec {
  pname = "apache-airflow";
  version = "1.10.14";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub rec {
    owner = "apache";
    repo = "airflow";
    rev = version;
    sha256 = "1kvrdx0xiw56q9913wqchir4xbwfixqm5kbvrsaygg9fqarghl1g";
  };

  propagatedBuildInputs = [
    alembic
    argcomplete
    cached-property
    cattrs
    colorlog
    configparser
    croniter
    dill
    email_validator
    flask
    flask-admin
    flask-appbuilder
    flask-bcrypt
    flask-caching
    flask_login
    flask-swagger
    flask_wtf
    funcsigs
    future
    GitPython
    graphviz
    gunicorn
    importlib-resources
    iso8601
    json-merge-patch
    jinja2
    ldap3
    lxml
    lazy-object-proxy
    markdown
    marshmallow-sqlalchemy
    pandas
    pendulum
    psutil
    pygments
    python-daemon
    python-dateutil
    python-nvd3
    python-slugify
    requests
    setproctitle
    sqlalchemy
    sqlalchemy-jsonfield
    tabulate
    tenacity
    termcolor
    thrift
    tzlocal
    unicodecsv
    werkzeug
    zope_deprecation
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
    typing-extensions
  ];

  checkInputs = [
    pytestCheckHook
    azure-common
    freezegun
    gunicorn
    hdfs
    hvac
    parameterized
    procps  # used for pgrep
    psycopg2
    sentry-sdk
    snakebite
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "flask>=1.1.0, <2.0" "flask" \
      --replace "jinja2>=2.10.1, <2.11.0" "jinja2" \
      --replace "pandas>=0.17.1, <2.0" "pandas" \
      --replace "flask-caching>=1.3.3, <1.4.0" "flask-caching" \
      --replace "flask-appbuilder~=2.2" "flask-appbuilder" \
      --replace "flask-admin==1.5.4" "flask-admin" \
      --replace "flask-login>=0.3, <0.5" "flask-login" \
      --replace "pendulum==1.4.4" "pendulum" \
      --replace "cached_property~=1.5" "cached_property" \
      --replace "dill>=0.2.2, <0.4" "dill" \
      --replace "configparser>=3.5.0, <3.6.0" "configparser" \
      --replace "jinja2>=2.10.1, <2.12.0" "jinja2" \
      --replace "colorlog==4.0.2" "colorlog" \
      --replace "funcsigs>=1.0.0, <2.0.0" "funcsigs" \
      --replace "flask-swagger>=0.2.13, <0.3" "flask-swagger" \
      --replace "python-daemon>=2.1.1" "python-daemon" \
      --replace "alembic>=1.0, <2.0" "alembic" \
      --replace "markdown>=2.5.2, <3.0" "markdown" \
      --replace "future>=0.16.0, <0.19" "future" \
      --replace "tenacity==4.12.0" "tenacity" \
      --replace "tzlocal>=1.4,<2.0.0" "tzlocal" \
      --replace "sqlalchemy~=1.3" "sqlalchemy" \
      --replace "sqlalchemy_jsonfield~=0.9" "sqlalchemy_jsonfield>=0.1" \
      --replace "gunicorn>=19.5.0, <21.0" "gunicorn" \
      --replace "werkzeug<1.0.0" "werkzeug" \
      --replace "importlib_resources~=1.4" "importlib_resources" \
      --replace "importlib-metadata~=2.0" "importlib-metadata>=1.0" \
      --replace "marshmallow-sqlalchemy>=0.16.1, <0.24.0" "marshmallow-sqlalchemy" \
      --replace "requests>=2.20.0, <2.24.0" "requests>=2.20.0" \
      --replace "lazy_object_proxy<1.5.0" "lazy-object-proxy"
    # NOTE: preference above is to relax the constraint completely, but when the constraint
    # is of format ``package>1.0.0; python_version<"3.7"``, we have to put ANY bound

    # fix issues w/ upgrade to pendulum >= 2.0
    substituteInPlace airflow/settings.py \
      --replace "from pendulum import Pendulum" "from pendulum import DateTime as Pendulum"
    substituteInPlace tests/core/test_core.py \
      --replace "from pendulum import utcnow" "import pendulum; import functools; utcnow = functools.partial(pendulum.now, 'UTC')"

    # --replace "from pendulum import utcnow" "from datetime import datetime as _dt; utcnow = _dt.utcnow"
  '';

  # allow for gunicorn processes to have access to python packages
  makeWrapperArgs = [ "--prefix PYTHONPATH : $PYTHONPATH" ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export AIRFLOW_HOME=$HOME
    export AIRFLOW__CORE__UNIT_TEST_MODE=True
    export AIRFLOW_DB="$HOME/airflow.db"
    export PATH=$PATH:$out/bin

    airflow version
    airflow initdb
    airflow db reset -y
  '';
  pytestFlagsArray = [
    # Subset of tests
    "tests/core/"
    "--durations=20"  # print duration of slowest 20 tests
  ];
  disabledTests = [
    # Broken with KeyError: visibility_timeout in "section_dict"
    "test_broker_transport_options"

    # Disabling tests > 20 seconds
    # not worth disabling test_cli_* or test_should_be* b/c it seems those do some slow setup, then remaining tests are fast
    "test_param_setup"
    "test_get_connections_env_var"
    "test_env_var_priority"
    "test_dbapi_get_sqlalchemy_engine"
    "test_dbapi_get_uri"
  ];

  meta = with lib; {
    description = "Programmatically author, schedule and monitor data pipelines";
    homepage = "http://airflow.apache.org/";
    changelog = "http://airflow.apache.org/docs/apache-airflow/stable/changelog.html";
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple costrouc ingenieroariel ];
  };
}
