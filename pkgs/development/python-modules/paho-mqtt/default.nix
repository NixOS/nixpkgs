{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, hatchling
, pysocks
, pytestCheckHook
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
  ]
  ++ optional-dependencies.proxy;

  preCheck = ''
    #  Traceback (most recent call last):
    #  File "/build/source/tests/lib/clients/01-asyncio.py", line 6, in <module>
    #     from tests.paho_test import get_test_server_port
    #  ModuleNotFoundError: No module named 'tests'
    export PYTHONPATH=$(pwd):$PYTHONPATH
  '';

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
