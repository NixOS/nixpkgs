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
, sqlalchemy-utils
, flask-mongoengine
, flask_sqlalchemy
, flask-babelex
, shapely
, geoalchemy2
, psycopg2
, arrow
, colour
, email_validator
, flask
, wtforms
, isPy27
, enum34
}:

buildPythonPackage rec {
  pname = "flask-admin";
  version = "1.5.6";

  src = fetchPypi {
    pname = "Flask-Admin";
    inherit version;
    sha256 = "1f31vzc0p2xni5mh1wvjk9jxf4ddlx2fj4r0f3vv2n9db3c63iv8";
  };

  checkInputs = [
    nose
    pillow
    mongoengine
    pymongo
    wtf-peewee
    sqlalchemy
    sqlalchemy-citext
    sqlalchemy-utils
    flask-mongoengine
    flask_sqlalchemy
    flask-babelex
    shapely
    geoalchemy2
    psycopg2
    arrow
    colour
    email_validator
  ];

  propagatedBuildInputs = [
    flask
    wtforms
  ] ++ lib.optionals isPy27 [ enum34 ];

  checkPhase = ''
    # disable tests that require mongodb, postresql, or network
    nosetests \
     -e "mongoengine" \
     -e "pymongo" \
     -e "test_form_upload" \
     -e "test_postgres" \
     -e "geoa" \
     -e "test_ajax_fk" \
     flask_admin/tests
  '';

  meta = with lib; {
    description = "Simple and extensible admin interface framework for Flask";
    homepage = "https://github.com/flask-admin/flask-admin/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
