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
  aiointercept,
  aioresponses,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "samsungtvws";
  version = "3.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xchwarze";
    repo = "samsung-tv-ws-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2o0CmMhlCx2yVitfwFXXjNQTrDDRlDcDV1kGv/pJxVo=";
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
    aiointercept
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "samsungtvws" ];

  meta = {
    description = "Samsung Smart TV WS API wrapper";
    homepage = "https://github.com/xchwarze/samsung-tv-ws-api";
    changelog = "https://github.com/xchwarze/samsung-tv-ws-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
