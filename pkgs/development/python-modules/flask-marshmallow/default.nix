{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, flit-core
, flask
, marshmallow
, packaging
, pytestCheckHook
, flask-sqlalchemy
, marshmallow-sqlalchemy
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "flask-marshmallow";
    rev = "refs/tags/${version}";
    hash = "sha256-xFIvTJBp3V4VLex8bvlbLIgLsyiwrVzrW1z9uNuOsCY=";
  };

  nativeBuildInputs = [
    flit-core
  ];

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
