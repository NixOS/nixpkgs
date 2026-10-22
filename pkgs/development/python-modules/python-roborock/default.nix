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
  syrupy_5,
  writableTmpDirAsHomeHook,
  zmqtt,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-roborock";
  version = "7.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Python-roborock";
    repo = "python-roborock";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S1rVkm0UPesQ0+s28uVD2ztjnaly0G2aUKHcCXBOroI=";
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
    syrupy_5
    writableTmpDirAsHomeHook
    zmqtt
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # url mocking mismatch, probably due to yarl update
    "test_url_cycling"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "roborock" ];

  meta = {
    description = "Python library & console tool for controlling Roborock vacuum";
    homepage = "https://github.com/Python-roborock/python-roborock";
    changelog = "https://github.com/Python-roborock/python-roborock/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "roborock";
  };
})
