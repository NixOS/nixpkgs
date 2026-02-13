{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build system
  setuptools,

  # propagates:
  requests,
  websocket-client,

  # extras: async
  aiohttp,
  websockets,

  # extras: encrypted
  cryptography,
  py3rijndael,

  # tests
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "samsungtvws";
  version = "3.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xchwarze";
    repo = "samsung-tv-ws-api";
    tag = "v${version}";
    hash = "sha256-yxCdcE5N/ZMRAkb0R8TT1jocMre0xv3EzpBXJ6Erkvg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    websocket-client
  ];

  optional-dependencies = {
    async = [
      aiohttp
      websockets
    ];
    encrypted = [
      cryptography
      py3rijndael
    ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ]
  ++ optional-dependencies.async
  ++ optional-dependencies.encrypted;

  pythonImportsCheck = [ "samsungtvws" ];

  meta = {
    description = "Samsung Smart TV WS API wrapper";
    homepage = "https://github.com/xchwarze/samsung-tv-ws-api";
    changelog = "https://github.com/xchwarze/samsung-tv-ws-api/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
