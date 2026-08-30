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
  pyyaml,
  regex,
  setuptools,
  tomlkit,
}:

buildPythonPackage rec {
  pname = "pytest-mypy-plugins";
  version = "4.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "typeddjango";
    repo = "pytest-mypy-plugins";
    tag = version;
    hash = "sha256-RyHoZniVLtunqz42tuVeAoiUm/e5JvvwX2MMCAJBhy8=";
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
  disabledTests = [ "test_no_silence_site_packages" ];

  meta = {
    description = "Pytest plugin for testing mypy types, stubs, and plugins";
    homepage = "https://github.com/TypedDjango/pytest-mypy-plugins";
    changelog = "https://github.com/typeddjango/pytest-mypy-plugins/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
