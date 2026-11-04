{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  openssl,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  testing = fetchFromGitHub {
    owner = "eclipse-paho";
    repo = "paho.mqtt.testing";
    rev = "a4dc694010217b291ee78ee13a6d1db812f9babd";
    hash = "sha256-SQoNdkWMjnasPjpXQF2yV97MUra8gb27pc3rNoA8Rjw=";
  };
in
buildPythonPackage rec {
  pname = "paho-mqtt";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse-paho";
    repo = "paho.mqtt.python";
    rev = "v${version}";
    hash = "sha256-gYCV8n+pNh62eDitfh4/mj4wu24GEthRtWV5Pa6M9bY=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    openssl
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "paho.mqtt" ];

  preCheck = ''
    ln -s ${testing} paho.mqtt.testing

    # paho.mqtt not in top-level dir to get caught by this
    export PYTHONPATH=".:$PYTHONPATH"
  '';

  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
  };

  meta = {
    changelog = "https://github.com/eclipse-paho/paho.mqtt.python/blob/${src.rev}/ChangeLog.txt";
    description = "MQTT version 5.0/3.1.1 client class";
    homepage = "https://eclipse.org/paho";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [
      mog
      dotlambda
    ];
  };
}
