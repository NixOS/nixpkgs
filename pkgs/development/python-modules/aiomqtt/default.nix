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
  version = "2.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sbtinstruments";
    repo = "aiomqtt";
    tag = "v${version}";
    hash = "sha256-S18jHHM1r077du/EO3WvCwLaYF70tIGdHatFxuTPhBs=";
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

  meta = {
    description = "Idiomatic asyncio MQTT client, wrapped around paho-mqtt";
    homepage = "https://github.com/sbtinstruments/aiomqtt";
    changelog = "https://github.com/sbtinstruments/aiomqtt/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
