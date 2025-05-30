{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  flask,
  werkzeug,
  pytestCheckHook,
  setuptools,

  # for passthru.tests
  aiobotocore,
  moto,
}:

buildPythonPackage rec {
  pname = "flask-cors";
  version = "6.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "corydolphin";
    repo = "flask-cors";
    tag = version;
    hash = "sha256-J9OTWVS0GXxfSedfHeifaJ0LR8xFKksf0RGsKSc581E=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    flask
    werkzeug
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  passthru.tests = {
    inherit aiobotocore moto;
  };

  meta = {
    description = "Flask extension adding a decorator for CORS support";
    homepage = "https://github.com/corydolphin/flask-cors";
    changelog = "https://github.com/corydolphin/flask-cors/releases/tag/${src.tag}";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
