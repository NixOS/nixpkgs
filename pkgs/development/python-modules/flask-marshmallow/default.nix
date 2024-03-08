{ lib
, buildPythonPackage
, fetchFromGitHub
, flask
, flask-sqlalchemy
, flit-core
, marshmallow
, marshmallow-sqlalchemy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "flask-marshmallow";
    rev = "refs/tags/${version}";
    hash = "sha256-QoktZcyVJXkHr8fCVYt3ZkYq52nxCsZu+AgaDyrZHWs=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    flask
    marshmallow
  ];

  passthru.optional-dependencies = {
    sqlalchemy = [
      flask-sqlalchemy
      marshmallow-sqlalchemy
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ passthru.optional-dependencies.sqlalchemy;

  pythonImportsCheck = [
    "flask_marshmallow"
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = {
    description = "Flask + marshmallow for beautiful APIs";
    homepage = "https://github.com/marshmallow-code/flask-marshmallow";
    changelog = "https://github.com/marshmallow-code/flask-marshmallow/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
