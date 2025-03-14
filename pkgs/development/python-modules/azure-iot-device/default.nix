{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  setuptools,

  urllib3,
  deprecation,
  paho-mqtt,
  requests,
  requests-unixsocket2,
  janus,
  pysocks,
  typing-extensions,
}:
buildPythonPackage rec {
  pname = "azure-iot-device";
  version = "2.14.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "azure_iot_device";
    hash = "sha256-ttSNSTLCQAJXNqzlRMTnG8SaFXasmY6h3neK+CSW/84=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    urllib3
    deprecation
    paho-mqtt
    requests
    requests-unixsocket2
    janus
    pysocks
    typing-extensions
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "azure.iot.device"
    "azure.iot.device.aio"
  ];

  meta = with lib; {
    # https://github.com/Azure/azure-iot-sdk-python/issues/1196
    broken = lib.versionAtLeast paho-mqtt.version "2";
    description = "Microsoft Azure IoT Device Library for Python";
    homepage = "https://github.com/Azure/azure-iot-sdk-python";
    license = licenses.mit;
    maintainers = with maintainers; [ mikut ];
  };
}
