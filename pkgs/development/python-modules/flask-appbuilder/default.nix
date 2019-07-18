{ lib
, buildPythonPackage
, fetchPypi
, nose
, apispec
, colorama
, click
, flask
, flask-babel
, flask_login
, flask-openid
, flask_sqlalchemy
, flask_wtf
, flask-jwt-extended
, jsonschema
, marshmallow
, marshmallow-enum
, marshmallow-sqlalchemy
, python-dateutil
, prison
, pyjwt
, pyyaml
, sqlalchemy-utils
}:

buildPythonPackage rec {
  pname = "flask-appbuilder";
  version = "2.1.6";

  src = fetchPypi {
    pname = "Flask-AppBuilder";
    inherit version;
    sha256 = "a37d7d6a62407a2e0975af5305c795f2fb5c06ecc34e3cf64659d083b1b2dd5f";
  };

  checkInputs = [
    nose
  ];

  propagatedBuildInputs = [
    apispec
    colorama
    click
    flask
    flask-babel
    flask_login
    flask-openid
    flask_sqlalchemy
    flask_wtf
    flask-jwt-extended
    jsonschema
    marshmallow
    marshmallow-enum
    marshmallow-sqlalchemy
    python-dateutil
    prison
    pyjwt
    sqlalchemy-utils
    pyyaml
  ];

  postPatch = ''
   substituteInPlace setup.py \
     --replace "jsonschema>=3.0.1<4" "jsonschema" \
     --replace "Flask-SQLAlchemy>=2.4,<3" "Flask-SQLAlchemy" \
     --replace "Flask-JWT-Extended>=3.18,<4" "Flask-JWT-Extended"
  '';

  checkPhase = ''
    # remove mockldap requirement
    rm flask_appbuilder/tests/_test_ldapsearch.py
    nosetests flask_appbuilder.api flask_appbuilder.tests.test_api
  '';

  # majority of tests require network access or mongo
  doCheck = false;

  meta = with lib; {
    description = "Simple and rapid application development framework, built on top of Flask";
    homepage = https://github.com/dpgaspar/flask-appbuilder/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
