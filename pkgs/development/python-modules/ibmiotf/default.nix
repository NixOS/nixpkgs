{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  iso8601,
  pytz,
  paho-mqtt,
  requests,
  requests-toolbelt,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "ibmiotf";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ibm-watson-iot";
    repo = "iot-python";
    tag = version;
    hash = "sha256-miNkOVPYf2EGlLKtx4UiOu/xkoffaPSiYbTpAA3El7I=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    iso8601
    pytz
    paho-mqtt
    requests
    requests-toolbelt
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Tests require network access and IBM Watson IoT Platform credentials
  doCheck = false;

  pythonImportsCheck = [ "ibmiotf" ];

  meta = {
    description = "Python Client for IBM Watson IoT Platform";
    homepage = "https://github.com/ibm-watson-iot/iot-python";
    changelog = "https://github.com/ibm-watson-iot/iot-python/releases/tag/${src.tag}";
    license = lib.licenses.epl10;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
