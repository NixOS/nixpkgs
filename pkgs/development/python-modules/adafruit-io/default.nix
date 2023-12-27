{ lib
, buildPythonPackage
, fetchFromGitHub
, paho-mqtt
, pytestCheckHook
, pythonOlder
, requests
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "adafruit-io";
  version = "2.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "Adafruit_IO_Python";
    rev = "refs/tags/${version}";
    hash = "sha256-vfjyU+czLtUA0WDEvc0iYmJ2Tn75o/OsX909clfDsUE=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    paho-mqtt
    requests
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "Adafruit_IO"
  ];

  disabledTestPaths = [
    # Tests requires valid credentials
    "tests/test_client.py"
    "tests/test_errors.py"
    "tests/test_mqtt_client.py"
  ];

  meta = with lib; {
    description = "Module for interacting with Adafruit IO";
    homepage = "https://github.com/adafruit/Adafruit_IO_Python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
