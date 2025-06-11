{
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  paho-mqtt,
  voluptuous,
}:

buildPythonPackage rec {
  pname = "pypglab";
  version = "0.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pglab-electronics";
    repo = "pypglab";
    tag = version;
    hash = "sha256-nnLGFVV+aWkaE7RnAzLHji/tKxIiA9qJS/BUTv3KNeo=";
  };

  build-system = [ hatchling ];

  dependencies = [
    voluptuous
    paho-mqtt
  ];

  pythonImportsCheck = [ "pypglab" ];

  # tests require physical hardware
  doCheck = false;

  meta = {
    description = "Asynchronous Python library to communicate with PG LAB Electronics devices over MQTT";
    homepage = "https://github.com/pglab-electronics/pypglab";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
