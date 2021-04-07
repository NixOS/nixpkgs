{ lib
, buildPythonPackage
, fetchPypi
, nose
, apispec
, colorama
, click
, email_validator
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
, sqlalchemy-utils
}:

buildPythonPackage rec {
  pname = "flask-appbuilder";
  version = "3.1.1";

  src = fetchPypi {
    pname = "Flask-AppBuilder";
    inherit version;
    sha256 = "076b020b0ba125339a2e710e74eab52648cde2b18599f7cb0fa1eada9bbb648c";
  };

  checkInputs = [
    nose
  ];

  propagatedBuildInputs = [
    apispec
    colorama
    click
    email_validator
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
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "apispec[yaml]>=3.3, <4" "apispec" \
      --replace "Flask-Login>=0.3, <0.5" "Flask-Login" \
      --replace "Flask-Babel>=1, <2" "Flask-Babel" \
      --replace "marshmallow-sqlalchemy>=0.22.0, <0.24.0" "marshmallow-sqlalchemy" \
      --replace "prison>=0.1.3, <1.0.0" "prison"
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
