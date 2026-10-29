{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
  six,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "pytest-voluptuous";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "F-Secure";
    repo = "pytest-voluptuous";
    tag = version;
    hash = "sha256-xdj4qCSSJQI9Rb1WyUYrAg1I5wQ5o6IJyIjJAafP/LY=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ pytest ];

  dependencies = [ voluptuous ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [ "pytest_voluptuous" ];

  enabledTestPaths = [ "tests/test_plugin.py" ];

  meta = {
    description = "Pytest plugin for asserting data against voluptuous schema";
    homepage = "https://github.com/F-Secure/pytest-voluptuous";
    changelog = "https://github.com/F-Secure/pytest-voluptuous/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
