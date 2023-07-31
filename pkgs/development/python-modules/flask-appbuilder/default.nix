{ lib
, buildPythonPackage
, fetchPypi
, apispec
, colorama
, click
, email-validator
, flask
, flask-babel
, flask-limiter
, flask-login
, flask-openid
, flask-sqlalchemy
, flask-wtf
, flask-jwt-extended
, jsonschema
, marshmallow
, marshmallow-enum
, marshmallow-sqlalchemy
, python-dateutil
, pythonOlder
, prison
, pyjwt
, pyyaml
, sqlalchemy-utils
}:

buildPythonPackage rec {
  pname = "flask-appbuilder";
  version = "4.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-AppBuilder";
    inherit version;
    hash = "sha256-FP92HEGOsufHtaIySqDiScD3QUu3iQhWdtvkOecUvuI=";
  };

  propagatedBuildInputs = [
    apispec
    colorama
    click
    email-validator
    flask
    flask-babel
    flask-limiter
    flask-login
    flask-openid
    flask-sqlalchemy
    flask-wtf
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
  ] ++ apispec.optional-dependencies.yaml;

  postPatch = ''
    substituteInPlace setup.py \
      --replace "apispec[yaml]>=3.3, <6" "apispec[yaml]" \
      --replace "Flask-SQLAlchemy>=2.4, <3" "Flask-SQLAlchemy" \
      --replace "Flask-Babel>=1, <3" "Flask-Babel" \
      --replace "marshmallow-sqlalchemy>=0.22.0, <0.27.0" "marshmallow-sqlalchemy" \
      --replace "prison>=0.2.1, <1.0.0" "prison"
  '';

  # Majority of tests require network access or mongo
  doCheck = false;

  pythonImportsCheck = [
    "flask_appbuilder"
  ];

  meta = with lib; {
    description = "Application development framework, built on top of Flask";
    homepage = "https://github.com/dpgaspar/flask-appbuilder/";
    changelog = "https://github.com/dpgaspar/Flask-AppBuilder/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    # Support for flask-sqlalchemy >= 3.0 is missing, https://github.com/dpgaspar/Flask-AppBuilder/pull/1940
    broken = true;
  };
}
