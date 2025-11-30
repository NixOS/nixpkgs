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
  version = "3.2.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = "pytest-mypy-plugins";
    tag = version;
    hash = "sha256-60VxMUUCIP+Mp+OsgdyRTPZVLGC/3iaMxxhw02ABB9k=";
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
