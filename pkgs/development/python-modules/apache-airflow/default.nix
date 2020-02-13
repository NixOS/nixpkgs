{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, fetchpatch
, alembic
, cached-property
, configparser
, colorlog
, croniter
, dill
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
, gunicorn
, iso8601
, json-merge-patch
, jinja2
, ldap3
, lxml
, lazy-object-proxy
, markdown
, pandas
, pendulum
, psutil
, pygments
, python-daemon
, python-dateutil
, requests
, setproctitle
, snakebite
, sqlalchemy
, tabulate
, tenacity
, termcolor
, text-unidecode
, thrift
, tzlocal
, unicodecsv
, werkzeug
, zope_deprecation
, enum34
, typing
, nose
, python
, isPy3k
}:

buildPythonPackage rec {
  pname = "apache-airflow";
  version = "1.10.5";
  disabled = (!isPy3k);

  src = fetchFromGitHub rec {
    owner = "apache";
    repo = "airflow";
    rev = version;
    sha256 = "14fmhfwx977c9jdb2kgm93i6acx43l45ggj30rb37r68pzpb6l6h";
  };

  patches = [
       # Not yet accepted: https://github.com/apache/airflow/pull/6562
     (fetchpatch {
       name = "avoid-warning-from-abc.collections";
       url = https://patch-diff.githubusercontent.com/raw/apache/airflow/pull/6562.patch;
       sha256 = "0swpay1qlb7f9kgc56631s1qd9k82w4nw2ggvkm7jvxwf056k61z";
     })
       # Not yet accepted: https://github.com/apache/airflow/pull/6561
     (fetchpatch {
       name = "pendulum2-compatibility";
       url = https://patch-diff.githubusercontent.com/raw/apache/airflow/pull/6561.patch;
       sha256 = "17hw8qyd4zxvib9zwpbn32p99vmrdz294r31gnsbkkcl2y6h9knk";
     })
  ];

  propagatedBuildInputs = [
    alembic
    cached-property
    colorlog
    configparser
    croniter
    dill
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
    gunicorn
    iso8601
    json-merge-patch
    jinja2
    ldap3
    lxml
    lazy-object-proxy
    markdown
    pandas
    pendulum
    psutil
    pygments
    python-daemon
    python-dateutil
    requests
    setproctitle
    sqlalchemy
    tabulate
    tenacity
    termcolor
    text-unidecode
    thrift
    tzlocal
    unicodecsv
    werkzeug
    zope_deprecation
  ];

  checkInputs = [
    snakebite
    nose
  ];

  postPatch = ''

   substituteInPlace setup.py \
     --replace "flask>=1.1.0, <2.0" "flask" \
     --replace "jinja2>=2.10.1, <2.11.0" "jinja2" \
     --replace "pandas>=0.17.1, <1.0.0" "pandas" \
     --replace "flask-caching>=1.3.3, <1.4.0" "flask-caching" \
     --replace "flask-appbuilder>=1.12.5, <2.0.0" "flask-appbuilder" \
     --replace "pendulum==1.4.4" "pendulum" \
     --replace "cached_property~=1.5" "cached_property" \
     --replace "dill>=0.2.2, <0.3" "dill" \
     --replace "configparser>=3.5.0, <3.6.0" "configparser" \
     --replace "jinja2>=2.7.3, <=2.10.0" "jinja2" \
     --replace "funcsigs==1.0.0" "funcsigs" \
     --replace "flask-swagger==0.2.13" "flask-swagger" \
     --replace "python-daemon>=2.1.1, <2.2" "python-daemon" \
     --replace "alembic>=0.9, <1.0" "alembic" \
     --replace "markdown>=2.5.2, <3.0" "markdown" \
     --replace "future>=0.16.0, <0.17" "future" \
     --replace "tenacity==4.12.0" "tenacity" \
     --replace "text-unidecode==1.2" "text-unidecode" \
     --replace "tzlocal>=1.4,<2.0.0" "tzlocal" \
     --replace "sqlalchemy~=1.3" "sqlalchemy" \
     --replace "gunicorn>=19.5.0, <20.0" "gunicorn" \
     --replace "werkzeug>=0.14.1, <0.15.0" "werkzeug"

  # dumb-init is only needed for CI and Docker, not relevant for NixOS.
  substituteInPlace setup.py \
     --replace "'dumb-init>=1.2.2'," ""

   substituteInPlace tests/core.py \
     --replace "/bin/bash" "${stdenv.shell}"
  '';

  checkPhase = ''
   export HOME=$(mktemp -d)
   export AIRFLOW_HOME=$HOME
   export AIRFLOW__CORE__UNIT_TEST_MODE=True
   export AIRFLOW_DB="$HOME/airflow.db"
   export PATH=$PATH:$out/bin

   airflow version
   airflow initdb
   airflow resetdb -y
   nosetests tests.core.CoreTest
   ## all tests
   # nosetests --cover-package=airflow
  '';

  meta = with lib; {
    description = "Programmatically author, schedule and monitor data pipelines";
    homepage = http://airflow.apache.org/;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc maintainers.ingenieroariel ];
  };
}
