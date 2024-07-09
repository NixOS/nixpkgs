{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "adafruit-io";
  version = "2.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "Adafruit_IO_Python";
    rev = "refs/tags/${version}";
    hash = "sha256-JBpF08WGe1pMK1y7HZLH/jSQkJtbWdiTGYHWRd39UIk=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    paho-mqtt
    requests
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "Adafruit_IO" ];

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
