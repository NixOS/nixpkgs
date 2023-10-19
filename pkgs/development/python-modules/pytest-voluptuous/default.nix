{ lib
, buildPythonPackage
, fetchFromGitHub
, pytest
, pytestCheckHook
, pythonOlder
, six
, voluptuous
}:

buildPythonPackage rec {
  pname = "pytest-voluptuous";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "F-Secure";
    repo = "pytest-voluptuous";
    rev = "refs/tags/${version}";
    hash = "sha256-xdj4qCSSJQI9Rb1WyUYrAg1I5wQ5o6IJyIjJAafP/LY=";
  };

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    voluptuous
  ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  pythonImportsCheck = [
    "pytest_voluptuous"
  ];

  pytestFlagsArray = [
    "tests/test_plugin.py"
  ];

  meta = with lib; {
    description = "A pytest plugin for asserting data against voluptuous schema";
    homepage = "https://github.com/F-Secure/pytest-voluptuous";
    changelog = "https://github.com/F-Secure/pytest-voluptuous/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
