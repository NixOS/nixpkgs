{ lib
, buildPythonPackage
, decorator
, fetchFromGitHub
, jinja2
, jsonschema
, mypy
, packaging
, pytest
, pytestCheckHook
, pythonOlder
, pyyaml
, regex
, setuptools
, tomlkit
}:

buildPythonPackage rec {
  pname = "pytest-mypy-plugins";
  version = "3.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = "pytest-mypy-plugins";
    rev = "refs/tags/${version}";
    hash = "sha256-kZbTCdZM+809yFkKWMpeyBOq6hcqcYk7rEYqee9hZwk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    decorator
    jinja2
    jsonschema
    mypy
    packaging
    pyyaml
    regex
    tomlkit
  ];

  pythonImportsCheck = [
    "pytest_mypy_plugins"
  ];

  nativeCheckInputs = [
    mypy
    pytestCheckHook
  ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  disabledTestPaths = [
    "pytest_mypy_plugins/tests/test_explicit_configs.py"
  ];

  meta = with lib; {
    description = "Pytest plugin for testing mypy types, stubs, and plugins";
    homepage = "https://github.com/TypedDjango/pytest-mypy-plugins";
    changelog = "https://github.com/typeddjango/pytest-mypy-plugins/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
