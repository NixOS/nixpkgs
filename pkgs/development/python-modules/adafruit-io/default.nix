{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt,
  pytestCheckHook,
  requests,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "adafruit-io";
  version = "2.8.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "Adafruit_IO_Python";
    tag = finalAttrs.version;
    hash = "sha256-JYQKrGg4FRzqq3wy/TqafC16rldvPEi+/xEI7XGvWM8=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
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

  meta = {
    description = "Module for interacting with Adafruit IO";
    homepage = "https://github.com/adafruit/Adafruit_IO_Python";
    changelog = "https://github.com/adafruit/Adafruit_IO_Python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
