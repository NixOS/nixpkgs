{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, flask
, marshmallow
, packaging
, pytestCheckHook
, flask-sqlalchemy
, marshmallow-sqlalchemy
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
  version = "0.15.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "flask-marshmallow";
    rev = "refs/tags/${version}";
    hash = "sha256-N21M/MzcvOaDh5BgbbZtNcpRAULtWGLTMberCfOUoEM=";
  };

  propagatedBuildInputs = [
    flask
    marshmallow
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.sqlalchemy;

  pythonImportsCheck = [
    "flask_marshmallow"
  ];

  passthru.optional-dependencies = {
    sqlalchemy = [
      flask-sqlalchemy
      marshmallow-sqlalchemy
    ];
  };

  meta = {
    description = "Flask + marshmallow for beautiful APIs";
    homepage = "https://github.com/marshmallow-code/flask-marshmallow";
    changelog = "https://github.com/marshmallow-code/flask-marshmallow/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
