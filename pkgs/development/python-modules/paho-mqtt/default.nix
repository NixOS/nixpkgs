{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

let
  testing = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.testing";
    rev = "a4dc694010217b291ee78ee13a6d1db812f9babd";
    hash = "sha256-SQoNdkWMjnasPjpXQF2yV97MUra8gb27pc3rNoA8Rjw=";
  };
in buildPythonPackage rec {
  pname = "paho-mqtt";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.python";
    rev = "v${version}";
    hash = "sha256-VMq+WTW+njK34QUUTE6fR2j2OmHxVzR0wrC92zYb1rY=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  pythonImportsCheck = [ "paho.mqtt" ];

  preCheck = ''
    ln -s ${testing} paho.mqtt.testing

    # paho.mqtt not in top-level dir to get caught by this
    export PYTHONPATH=".:$PYTHONPATH"
  '';

  meta = with lib; {
    changelog = "https://github.com/eclipse/paho.mqtt.python/blob/${src.rev}/ChangeLog.txt";
    description = "MQTT version 5.0/3.1.1 client class";
    homepage = "https://eclipse.org/paho";
    license = licenses.epl20;
    maintainers = with maintainers; [
      mog
      dotlambda
    ];
  };
}
