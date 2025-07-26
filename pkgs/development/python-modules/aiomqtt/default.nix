{
  lib,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  paho-mqtt,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiomqtt";
  version = "2.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sbtinstruments";
    repo = "aiomqtt";
    tag = "v${version}";
    hash = "sha256-b7kCLpJzZGx8YpC0M4O4fqFh3xP73CXFWbKaggD6bOI=";
  };

  build-system = [ hatchling ];

  dependencies = [ paho-mqtt ];

  nativeCheckInputs = [
    anyio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiomqtt" ];

  disabledTestMarks = [
    "network"
  ];

  meta = with lib; {
    description = "Idiomatic asyncio MQTT client, wrapped around paho-mqtt";
    homepage = "https://github.com/sbtinstruments/aiomqtt";
    changelog = "https://github.com/sbtinstruments/aiomqtt/blob/${src.tag}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
