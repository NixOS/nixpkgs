{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  paho-mqtt,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "aiomqtt";
  version = "2.3.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "sbtinstruments";
    repo = "aiomqtt";
    tag = "v${version}";
    hash = "sha256-1UTCcvzbuZJ3KpYsVxiaVn9MjjS1MYYduM4jASAOR3Y=";
  };

  build-system = [ hatchling ];

  dependencies = [ paho-mqtt ];

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
