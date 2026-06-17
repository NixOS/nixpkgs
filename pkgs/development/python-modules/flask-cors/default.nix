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
  version = "6.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "corydolphin";
    repo = "flask-cors";
    tag = version;
    hash = "sha256-9WlD5Qd0WiBDrVHf5nT1qAK2gtYavlPnY7qFkiAgxws=";
  };

  # actually use the current version value
  # taken from .github/workflows/on-release-main.yml
  postPatch = ''
    sed -i "s/^version = \".*\"/version = \"$version\"/" pyproject.toml
    sed -i "s/__version__ .*/__version__ = \"$version\"/" flask_cors/version.py
  '';

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
