{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
}:

buildPythonPackage rec {
  pname = "qbusmqttapi";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Qbus-iot";
    repo = "qbusmqttapi";
    tag = "v${version}";
    hash = "sha256-8TNtfBxJcSwlcAgKF6Gvn+e4NGbOIE3JWBAgFKmNyKA=";
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
