{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, flit-core
, flask
, marshmallow
, pytestCheckHook
, flask-sqlalchemy
, marshmallow-sqlalchemy
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
  version = "1.1.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "flask-marshmallow";
    rev = "refs/tags/${version}";
    hash = "sha256-+5L4OfBRMkS6WRXT7dI/uuqloc/PZgu+DFvOCinByh8=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    flask
    marshmallow
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
