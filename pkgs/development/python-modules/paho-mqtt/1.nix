{
  buildPythonPackage,
  esphome,
  fetchFromGitHub,
  lib,
  pytestCheckHook,
  setuptools,
}:

let
  testing = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.testing";
    rev = "a4dc694010217b291ee78ee13a6d1db812f9babd";
    hash = "sha256-SQoNdkWMjnasPjpXQF2yV97MUra8gb27pc3rNoA8Rjw=";
  };
in
buildPythonPackage (finalAttrs: {
  pname = "paho-mqtt";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9nH6xROVpmI+iTKXfwv2Ar1PAmWbEunI3HO0pZyK6Rg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "paho.mqtt" ];

  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    ln -s ${testing} paho.mqtt.testing

    # paho.mqtt not in top-level dir to get caught by this
    export PYTHONPATH=".:$PYTHONPATH"
  '';

  disabledTests = [
    # Fails during teardown
    # RuntimeError: Client 01-zero-length-clientid.py exited with code None, expected 0
    "test_01_zero_length_clientid"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/eclipse/paho.mqtt.python/blob/${finalAttrs.src.tag}/ChangeLog.txt";
    description = "MQTT version 5.0/3.1.1 client class";
    homepage = "https://eclipse.org/paho";
    license = lib.licenses.epl20;
    inherit (esphome.meta) maintainers;
  };
})
