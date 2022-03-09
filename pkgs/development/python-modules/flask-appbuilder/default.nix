{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
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
, pythonOlder
, prison
, pyjwt
, pyyaml
, sqlalchemy-utils
}:

buildPythonPackage rec {
  pname = "flask-appbuilder";
  version = "3.4.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "Flask-AppBuilder";
    inherit version;
    sha256 = "sha256-uZzuvNusqMzAS/vmg3CuZ+D442J4LbFwsBboVIx/srE=";
  };

  # See here: https://github.com/dpgaspar/Flask-AppBuilder/commit/7097a7b133f27c78d2b54d2a46e4a4c24478a066.patch
  #           https://github.com/dpgaspar/Flask-AppBuilder/pull/1610
  # The patch from the PR doesn't apply cleanly so I edited it manually.
  patches = [
    ./upgrade-to-flask_jwt_extended-4.patch
    (fetchpatch {
      # https://github.com/dpgaspar/Flask-AppBuilder/pull/1734
      name = "flask-appbuilder-wtf3.patch";
      url = "https://github.com/dpgaspar/Flask-AppBuilder/commit/bccb3d719cd3ceb872fe74a9ab304d74664fbf43.patch";
      sha256 = "1rsci0ynb7y6k53j164faggjr2g6l5v78w7953qbxcy8f55sb2fv";
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
      --replace "apispec[yaml]>=3.3, <4" "apispec[yaml] >=3.3" \
      --replace "Flask>=0.12, <2" "Flask" \
      --replace "Flask-Login>=0.3, <0.5" "Flask-Login >=0.3, <0.6" \
      --replace "Flask-Babel>=1, <2" "Flask-Babel >=1, <3" \
      --replace "Flask-WTF>=0.14.2, <0.15.0" "Flask-WTF" \
      --replace "WTForms<3.0.0" "WTForms" \
      --replace "marshmallow-sqlalchemy>=0.22.0, <0.27.0" "marshmallow-sqlalchemy" \
      --replace "Flask-JWT-Extended>=3.18, <4" "Flask-JWT-Extended>=4.1.0" \
      --replace "PyJWT>=1.7.1, <2.0.0" "PyJWT>=2.0.1" \
      --replace "prison>=0.2.1, <1.0.0" "prison" \
      --replace "SQLAlchemy<1.4.0" "SQLAlchemy"
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
