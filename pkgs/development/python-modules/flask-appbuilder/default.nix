{ lib
, buildPythonPackage
, fetchPypi
, apispec
, colorama
, click
, email_validator
, fetchpatch
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
  version = "3.3.0";

  src = fetchPypi {
    pname = "Flask-AppBuilder";
    inherit version;
    sha256 = "00dsfv1apl6483wy20aj91f9h5ak2casbx5vcajv2nd3i7c7v8gx";
  };

  patches = [
    # https://github.com/dpgaspar/Flask-AppBuilder/pull/1610
    (fetchpatch {
      name = "flask_jwt_extended-and-pyjwt-patch";
      url = "https://github.com/dpgaspar/Flask-AppBuilder/commit/7097a7b133f27c78d2b54d2a46e4a4c24478a066.patch";
      sha256 = "sha256-ZpY8+2Hoz3z01GVtw2OIbQcsmAwa7iwilFWzgcGhY1w=";
      includes = [ "flask_appbuilder/security/manager.py" "setup.py" ];
    })
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
    pyyaml
    sqlalchemy-utils
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "apispec[yaml]>=3.3, <4" "apispec[yaml] >=3.3, <5" \
      --replace "Flask-Login>=0.3, <0.5" "Flask-Login >=0.3, <0.6" \
      --replace "Flask-Babel>=1, <2" "Flask-Babel >=1, <3" \
      --replace "marshmallow-sqlalchemy>=0.22.0, <0.24.0" "marshmallow-sqlalchemy >=0.22.0, <0.25.0"
  '';

  # Majority of tests require network access or mongo
  doCheck = false;

  pythonImportsCheck = [ "flask_appbuilder" ];

  meta = with lib; {
    description = "Simple and rapid application development framework, built on top of Flask";
    homepage = "https://github.com/dpgaspar/flask-appbuilder/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
