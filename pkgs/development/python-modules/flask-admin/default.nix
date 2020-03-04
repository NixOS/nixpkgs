{ lib
, buildPythonPackage
, fetchPypi
, nose
, pillow
, mongoengine
, pymongo
, wtf-peewee
, sqlalchemy
, sqlalchemy-citext
, flask-mongoengine
, flask_sqlalchemy
, flask-babelex
, shapely
, geoalchemy2
, psycopg2
, flask
, wtforms
, isPy27
, enum34
}:

buildPythonPackage rec {
  pname = "flask-admin";
  version = "1.5.3";

  src = fetchPypi {
    pname = "Flask-Admin";
    inherit version;
    sha256 = "ca0be6ec11a6913b73f656c65c444ae5be416c57c75638dd3199376ce6bc7422";
  };

  checkInputs = [
    nose
    pillow
    mongoengine
    pymongo
    wtf-peewee
    sqlalchemy
    sqlalchemy-citext
    flask-mongoengine
    flask_sqlalchemy
    flask-babelex
    shapely
    geoalchemy2
    psycopg2
  ];

  propagatedBuildInputs = [
    flask
    wtforms
  ] ++ lib.optionals isPy27 [ enum34 ];

  checkPhase = ''
    # disable tests that require mongodb, postresql
    nosetests \
     -e "mongoengine" \
     -e "pymongo" \
     -e "test_form_upload" \
     -e "test_postgres" \
     -e "geoa" \
     flask_admin/tests
  '';

  meta = with lib; {
    description = "Simple and extensible admin interface framework for Flask";
    homepage = https://github.com/flask-admin/flask-admin/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
