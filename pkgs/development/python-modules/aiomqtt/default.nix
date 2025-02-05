{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  paho-mqtt_2,
  poetry-core,
  poetry-dynamic-versioning,
  pytestCheckHook,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "aiomqtt";
  version = "2.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "sbtinstruments";
    repo = "aiomqtt";
    tag = "v${version}";
    hash = "sha256-a0z4Tv0x25Qd/ZMxUZmtYqrwlD7MugfHdsx+TGfBCYY=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    paho-mqtt_2
    typing-extensions
  ];

  nativeCheckInputs = [
    anyio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiomqtt" ];

  pytestFlagsArray = [
    "-m"
    "'not network'"
  ];

  meta = with lib; {
    description = "Idiomatic asyncio MQTT client, wrapped around paho-mqtt";
    homepage = "https://github.com/sbtinstruments/aiomqtt";
    changelog = "https://github.com/sbtinstruments/aiomqtt/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
