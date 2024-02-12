{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, hatchling
, pytestCheckHook
}:

let
  testing = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.testing";
    rev = "9d7bb80bb8b9d9cfc0b52f8cb4c1916401281103";
    hash = "sha256-3QqCLgV4WMZuG8+3nIa3g9PtzH7cXjw1fWbZkj7H3RU=";
  };
in buildPythonPackage rec {
  pname = "paho-mqtt";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.python";
    rev = "v${version}";
    hash = "sha256-dR/MCz3c9eHai76I17PGD71E5/nZVEo6uRwUULOzKQU=";
  };

  build-system = [
    hatchling
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  doCheck = !stdenv.isDarwin;

  preCheck = ''
    ln -s ${testing} paho.mqtt.testing

    export PYTHONPATH=".:$PYTHONPATH"
  '';

  pythonImportsCheck = [
    "paho.mqtt"
  ];

  meta = with lib; {
    changelog = "https://github.com/eclipse/paho.mqtt.python/blob/${src.rev}/ChangeLog.txt";
    description = "MQTT version 5.0/3.1.1 client class";
    homepage = "https://eclipse.org/paho";
    license = licenses.epl20;
    maintainers = with maintainers; [ mog dotlambda ];
  };
}
