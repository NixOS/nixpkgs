{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  apispec,
  colorama,
  click,
  email-validator,
  flask,
  flask-babel,
  flask-limiter,
  flask-login,
  flask-openid,
  flask-sqlalchemy,
  flask-wtf,
  flask-jwt-extended,
  jsonschema,
  marshmallow,
  marshmallow-sqlalchemy,
  python-dateutil,
  prison,
  pyjwt,
  sqlalchemy-utils,
  wtforms,
  werkzeug,
}:

buildPythonPackage rec {
  pname = "flask-appbuilder";
  version = "5.0.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "dpgaspar";
    repo = "Flask-AppBuilder";
    tag = "v${version}";
    hash = "sha256-Klj36981KbtOHTyl2QcFvSYYkw2qU2feen8KbS5+aXg=";
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
    marshmallow-sqlalchemy
    python-dateutil
    prison
    pyjwt
    sqlalchemy-utils
    wtforms
    werkzeug
  ]
  ++ apispec.optional-dependencies.yaml;

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "prison>=0.2.1, <1.0.0" "prison"
  '';

  # Majority of tests require network access or mongo
  doCheck = false;

  pythonImportsCheck = [ "flask_appbuilder" ];

  meta = {
    description = "Application development framework, built on top of Flask";
    homepage = "https://github.com/dpgaspar/flask-appbuilder/";
    changelog = "https://github.com/dpgaspar/Flask-AppBuilder/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
