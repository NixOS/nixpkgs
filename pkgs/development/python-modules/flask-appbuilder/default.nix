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
  version = "2.3.0";

  src = fetchPypi {
    pname = "Flask-AppBuilder";
    inherit version;
    sha256 = "04bsswi7daaqda01a83rd1f2gq6asii520f9arjf7bsy24pmbprc";
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
      --replace "apispec[yaml]>=1.1.1, <2" "apispec" \
      --replace "jsonschema>=3.0.1, <4" "jsonschema" \
      --replace "marshmallow>=2.18.0, <4.0.0" "marshmallow" \
      --replace "PyJWT>=1.7.1" "PyJWT" \
      --replace "Flask-SQLAlchemy>=2.4, <3" "Flask-SQLAlchemy" \
      --replace "Flask-JWT-Extended>=3.18, <4" "Flask-JWT-Extended" \
      --replace "Flask-Login>=0.3, <0.5" "Flask-Login"
  '';

  # majority of tests require network access or mongo
  doCheck = false;

  meta = with lib; {
    description = "Simple and rapid application development framework, built on top of Flask";
    homepage = "https://github.com/dpgaspar/flask-appbuilder/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
