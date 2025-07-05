{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "qbusmqttapi";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qbus-iot";
    repo = "qbusmqttapi";
    tag = "v${version}";
    hash = "sha256-1Srp1FOnTw7TwE0OTY+q6R1d/M7/LH9leCUZMADE++Y=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "qbusmqttapi" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "MQTT API for Qbus Home Automation";
    homepage = "https://github.com/Qbus-iot/qbusmqttapi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
