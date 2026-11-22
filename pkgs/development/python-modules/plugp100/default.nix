{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  certifi,
  scapy,
  urllib3,
  semantic-version,
  aiohttp,
  jsons,
  requests,
  cryptography,
  # Test inputs
  pytestCheckHook,
  pytest-asyncio,
}:

buildPythonPackage (finalAttrs: {
  pname = "plugp100";
  version = "6.0.0.dev2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petretiandrea";
    repo = "plugp100";
    tag = lib.replaceStrings [ ".dev" ] [ "-dev." ] finalAttrs.version;
    hash = "sha256-wYt51HwoRJzuJ+YW+mmB6ZosJGEz7DcRGfkFGQZ0DJE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    certifi
    cryptography
    jsons
    requests
    scapy
    semantic-version
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  disabledTestPaths = [
    "tests/integration/"
    "tests/unit/hub_child/"
    "tests/unit/test_plug_strip.py"
    "tests/unit/test_hub.py"
    "tests/unit/test_klap_protocol.py"
  ];

  meta = {
    description = "Python library to control Tapo Plug P100 devices";
    homepage = "https://github.com/petretiandrea/plugp100";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ pyle ];
  };
})
