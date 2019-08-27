{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, fetchFromGitHub
, alembic
, configparser
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
, text-unidecode
, thrift
, tzlocal
, unicodecsv
, werkzeug
, zope_deprecation
, enum34
, typing
, nose
, isPy27
, python
, nixpkgs-pytools
}:

let # import error "from pendulum import Pendulum" due to 2.x
    pendulum_1_4_4 = pendulum.overrideAttrs (super: rec {
      name = "pendulum-1.4.4";

      src = fetchPypi {
        pname = super.pname;
        version = "1.4.4";
        sha256 = "0p5c7klnfjw8f63x258rzbhnl1p0hn83lqdnhhblps950k5m47k0";
      };

      postInstall = ''
        ${nixpkgs-pytools}/bin/python-rewrite-imports --path $out/${python.sitePackages}/ \
          --replace pendulum pendulum_1_4_4_040d1wbkcapkgb220yzk2dicnghhynj24m2xlbmqg6j54f007j94

        # remove btye compiled files
        find $out/${python.sitePackages} -type f -name '*.pyc' -delete

        # rename dist
        mv $out/${python.sitePackages}/pendulum-1.4.4.dist-info $out/${python.sitePackages}/pendulum_1_4_4_040d1wbkcapkgb220yzk2dicnghhynj24m2xlbmqg6j54f007j94-1.4.4.dist-info
      '';

     propagatedBuildInputs = super.propagatedBuildInputs ++ [ tzlocal ];
    });

    # 2.x has fstrings
    flask-appbuilder_1_12_3 = flask-appbuilder.overrideAttrs (super: rec {
      name = "flask-appbuilder-1.12.3";

      src = fetchPypi {
        pname = "Flask-AppBuilder";
        version = "1.12.3";
        sha256 = "1mgz833sbgbw8v881v5wfr0vzkl4gl2m9i1zpl37d09ixxz0ljmw";
      };

      buildPhase = ''
       substituteInPlace setup.py \
         --replace "prison==0.1.0" "prison"
      '' + super.buildPhase;

      postInstall = ''
        ${nixpkgs-pytools}/bin/python-rewrite-imports --path $out/${python.sitePackages}/ \
          --replace flask_appbuilder flask_appbuilder_1_12_3_040d1wbkcapkgb220yzk2dicnghhynj24m2xlbmqg6j54f007j94

        # remove btye compiled files
        find $out/${python.sitePackages} -type f -name '*.pyc' -delete

        # rename dist
        mv $out/${python.sitePackages}/Flask_AppBuilder-1.12.3.dist-info $out/${python.sitePackages}/Flask_AppBuilder_1_12_3_040d1wbkcapkgb220yzk2dicnghhynj24m2xlbmqg6j54f007j94-1.12.3.dist-info
      '';
    });
in
buildPythonPackage rec {
  pname = "apache-airflow";
  version = "1.10.3";

  src = fetchFromGitHub rec {
    owner = "apache";
    repo = "airflow";
    rev = version;
    sha256 = "040d1wbkcapkgb220yzk2dicnghhynj24m2xlbmqg6j54f007j94";
  };

  propagatedBuildInputs = [
    alembic
    configparser
    croniter
    dill
    flask
    flask-admin
    flask-appbuilder
    flask-appbuilder_1_12_3
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
    markdown
    pandas
    pendulum
    pendulum_1_4_4
    psutil
    pygments
    python-daemon
    python-dateutil
    requests
    setproctitle
    sqlalchemy
    tabulate
    tenacity
    text-unidecode
    thrift
    tzlocal
    unicodecsv
    werkzeug
    zope_deprecation
  ] ++ lib.optionals isPy27 [ enum34 typing ];

  checkInputs = [
    snakebite
    nose
  ];

  postPatch = ''
   ${nixpkgs-pytools}/bin/python-rewrite-imports --path $PWD \
     --replace flask_appbuilder flask_appbuilder_1_12_3_040d1wbkcapkgb220yzk2dicnghhynj24m2xlbmqg6j54f007j94 \
     --replace pendulum pendulum_1_4_4_040d1wbkcapkgb220yzk2dicnghhynj24m2xlbmqg6j54f007j94

   substituteInPlace setup.py \
     --replace "flask-caching>=1.3.3, <1.4.0" "flask-caching" \
     --replace "flask-appbuilder==1.12.3" "flask-appbuilder" \
     --replace "pendulum==1.4.4" "pendulum" \
     --replace "configparser>=3.5.0, <3.6.0" "configparser" \
     --replace "jinja2>=2.7.3, <=2.10.0" "jinja2" \
     --replace "funcsigs==1.0.0" "funcsigs" \
     --replace "flask-swagger==0.2.13" "flask-swagger" \
     --replace "python-daemon>=2.1.1, <2.2" "python-daemon" \
     --replace "alembic>=0.9, <1.0" "alembic" \
     --replace "markdown>=2.5.2, <3.0" "markdown" \
     --replace "future>=0.16.0, <0.17" "future" \
     --replace "tenacity==4.12.0" "tenacity" \
     --replace "werkzeug>=0.14.1, <0.15.0" "werkzeug"

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
    maintainers = [ maintainers.costrouc ];
  };
}
