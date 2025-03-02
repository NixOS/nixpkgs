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
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pglab-electronics";
    repo = "pypglab";
    # https://github.com/pglab-electronics/pypglab/issues/1
    rev = "bb4f0010ea01c63942443b496d7ad32852c5e2ad";
    hash = "sha256-b+o98DrTK1HBKvRfTjdJ1MkdUHEg/TaQZhoLR7URZ0c=";
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
