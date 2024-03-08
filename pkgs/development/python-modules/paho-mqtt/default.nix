{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pysocks
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "paho-mqtt";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse";
    repo = "paho.mqtt.python";
    rev = "refs/tags/v${version}";
    hash = "sha256-dR/MCz3c9eHai76I17PGD71E5/nZVEo6uRwUULOzKQU=";
  };

  build-system = [
    hatchling
  ];

  optional-dependencies.proxy = [
    pysocks
  ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ]
  ++ optional-dependencies.proxy;

  doCheck = !stdenv.isDarwin;

  pythonImportsCheck = [
    "paho.mqtt"
  ];

  meta = with lib; {
    description = "MQTT version 3.1.1 client class";
    homepage = "https://eclipse.org/paho";
    license = licenses.epl10;
    maintainers = with maintainers; [ mog dotlambda ];
  };
}
