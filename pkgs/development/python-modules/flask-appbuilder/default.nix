{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, apispec
, colorama
, click
, email-validator
, flask
, flask-babel
, flask_login
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
  version = "4.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-AppBuilder";
    inherit version;
    hash = "sha256-g+iHUL83PokXPGu7HJ8ffLocQr0uGpMqS5MbfIlZZ2E=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/dpgaspar/Flask-AppBuilder/pull/1734
      name = "flask-appbuilder-wtf3.patch";
      url = "https://github.com/dpgaspar/Flask-AppBuilder/commit/bccb3d719cd3ceb872fe74a9ab304d74664fbf43.patch";
      sha256 = "sha256-8NaTr0RcnsVik/AB4g8QL+FkcRlgkkASFe8fXIvFt/A=";
      excludes = [
        "requirements.txt"
        "setup.py"
        "examples/employees/app/views.py"
      ];
    })
  ];

  propagatedBuildInputs = [
    apispec
    colorama
    click
    email-validator
    flask
    flask-babel
    flask_login
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
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "apispec[yaml]>=3.3, <4" "apispec[yaml] >=3.3" \
      --replace "Flask-Login>=0.3, <0.5" "Flask-Login >=0.3" \
      --replace "Flask-WTF>=0.14.2, <0.15.0" "Flask-WTF" \
      --replace "WTForms<3.0.0" "WTForms" \
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
