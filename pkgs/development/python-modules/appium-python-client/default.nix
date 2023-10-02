{ fetchFromGitHub
, buildPythonPackage
, selenium
, pytestCheckHook
, pythonOlder
, python-dateutil
, mock
, httpretty
, typing-extensions
, types-python-dateutil
, lib
}:

buildPythonPackage rec {
  pname = "appium-python-client";
  version = "2.11.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "appium";
    repo = "python-client";
    rev = "v${version}";
    hash = "sha256-XI1JfeTmMxP6UVZ6lxpRc1R2KB0JRQNEP6beDnAzzEk=";
  };

  propagatedBuildInputs = [ selenium ];

  nativeCheckInputs = [
    pytestCheckHook

    # upstream does not distinguish between dev and test dependencies,
    # added dependencies probably used on tests
    httpretty
    mock
    python-dateutil
    typing-extensions
    types-python-dateutil
  ];

  disabledTestPaths = [
    "test/functional/mac/execute_script_test.py"
    "test/functional/mac/webelement_test.py"
  ];

  meta = with lib;{
    description = "Python language bindings for Appium";
    longDescription = "An extension library for adding WebDriver Protocol and Appium commands to the Selenium Python language binding for use with the mobile testing framework Appium.";
    homepage = "https://github.com/appium/python-client";
    license = licenses.asl20;
    maintainers = with maintainers; [ Alper-Celik ];
  };

}
