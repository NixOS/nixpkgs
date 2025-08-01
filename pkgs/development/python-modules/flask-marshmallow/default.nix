{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  flask-sqlalchemy,
  flit-core,
  marshmallow,
  marshmallow-sqlalchemy,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "flask-marshmallow";
    tag = version;
    hash = "sha256-dK2bE5mZiFh0nAN2yRpABT+SGG/UGWJ1oDtnD6bgyXk=";
  };

  build-system = [ flit-core ];

  dependencies = [
    flask
    marshmallow
  ];

  optional-dependencies = {
    sqlalchemy = [
      flask-sqlalchemy
      marshmallow-sqlalchemy
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ optional-dependencies.sqlalchemy;

  pythonImportsCheck = [ "flask_marshmallow" ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  meta = {
    description = "Flask + marshmallow for beautiful APIs";
    homepage = "https://github.com/marshmallow-code/flask-marshmallow";
    changelog = "https://github.com/marshmallow-code/flask-marshmallow/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
