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
  pycryptodome,
  pycryptodomex,
  pyrate-limiter,
  pytest-asyncio,
  pytestCheckHook,
  vacuum-map-parser-roborock,
  click-shell,
  syrupy,
}:

buildPythonPackage rec {
  pname = "python-roborock";
  version = "3.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Python-roborock";
    repo = "python-roborock";
    tag = "v${version}";
    hash = "sha256-Ts1X07eTv4KXv344F3fGazHlDx6XXGQfdmxb+gd/0qc=";
  };

  pythonRelaxDeps = [ "pycryptodome" ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    aiomqtt
    click
    construct
    paho-mqtt
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

  pythonImportsCheck = [ "roborock" ];

  meta = {
    description = "Python library & console tool for controlling Roborock vacuum";
    homepage = "https://github.com/Python-roborock/python-roborock";
    changelog = "https://github.com/Python-roborock/python-roborock/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "roborock";
  };
}
