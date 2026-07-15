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
  pyshark,
  pytest-asyncio,
  pytestCheckHook,
  pyyaml,
  vacuum-map-parser-roborock,
  click-shell,
  syrupy,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-roborock";
  version = "5.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Python-roborock";
    repo = "python-roborock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uj7rr9vAdZBseeePQU1/3bILwsI0P2CDy1bGu6R90Cg=";
  };

  pythonRelaxDeps = [
    "protobuf"
    "pycryptodome"
  ];

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    aiomqtt
    construct
    paho-mqtt
    protobuf
    pycryptodome
    pyrate-limiter
    vacuum-map-parser-roborock
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ pycryptodomex ];

  optional-dependencies.cli = [
    click
    click-shell
    pyyaml
    pyshark
  ];

  nativeCheckInputs = [
    aioresponses
    freezegun
    pytest-asyncio
    pytestCheckHook
    syrupy
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

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
