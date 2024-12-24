{
  lib,
  buildPythonPackage,
  decorator,
  fetchFromGitHub,
  jinja2,
  jsonschema,
  mypy,
  packaging,
  pytest,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
  regex,
  setuptools,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "pytest-mypy-plugins";
  version = "3.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = "pytest-mypy-plugins";
    rev = "refs/tags/${version}";
    hash = "sha256-yme1g9Kj5guao0Lf8mbkNJRw6ipS2Wd4Io1cSlEBAGo=";
  };

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [
    decorator
    jinja2
    jsonschema
    mypy
    packaging
    pyyaml
    regex
    tomlkit
  ];

  pythonImportsCheck = [ "pytest_mypy_plugins" ];

  nativeCheckInputs = [
    mypy
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTestPaths = [ "pytest_mypy_plugins/tests/test_explicit_configs.py" ];

  meta = with lib; {
    description = "Pytest plugin for testing mypy types, stubs, and plugins";
    homepage = "https://github.com/TypedDjango/pytest-mypy-plugins";
    changelog = "https://github.com/typeddjango/pytest-mypy-plugins/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
