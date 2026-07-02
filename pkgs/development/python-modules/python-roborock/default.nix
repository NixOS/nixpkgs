{
  lib,
  stdenv,
  aiohttp,
  aiomqtt,
  aioresponses,
  buildPythonPackage,
  click,
  construct,
  fetchFromGitHub,
  freezegun,
  hatchling,
  paho-mqtt,
  protobuf,
  pycryptodome,
  pycryptodomex,
  pyrate-limiter,
  pytest-asyncio,
  pytestCheckHook,
  vacuum-map-parser-roborock,
  click-shell,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-roborock";
  version = "5.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Python-roborock";
    repo = "python-roborock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-v4hONQ3EmpenjnAVKm8YMrynVyxtduefN5oqGW9MoE0=";
  };

  pythonRelaxDeps = [
    "protobuf"
    "pycryptodome"
  ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    aiomqtt
    click
    construct
    paho-mqtt
    protobuf
    pycryptodome
    pyrate-limiter
    vacuum-map-parser-roborock
    click-shell
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ pycryptodomex ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
    syrupy
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "roborock" ];

  meta = {
    description = "Python library & console tool for controlling Roborock vacuum";
    homepage = "https://github.com/Python-roborock/python-roborock";
    changelog = "https://github.com/Python-roborock/python-roborock/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "roborock";
  };
})
