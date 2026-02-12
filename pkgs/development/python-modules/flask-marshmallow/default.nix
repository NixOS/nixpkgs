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
}:

buildPythonPackage rec {
  pname = "flask-marshmallow";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marshmallow-code";
    repo = "flask-marshmallow";
    tag = version;
    hash = "sha256-YyXsCyIJmXb1p1J5wvGg57bGbsAbz83vW6hxpnbpOSw=";
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
