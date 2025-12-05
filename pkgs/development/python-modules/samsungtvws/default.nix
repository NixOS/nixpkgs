{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

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
  version = "2.7.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xchwarze";
    repo = "samsung-tv-ws-api";
    tag = "v${version}";
    hash = "sha256-CU59Kg8kSEE71x6wifCKCaVFdaMftodtkrAOpD+qvWY=";
  };

  patches = [
    # https://github.com/xchwarze/samsung-tv-ws-api/pull/159
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio.timeout.patch";
      url = "https://github.com/xchwarze/samsung-tv-ws-api/commit/c5b363aababe0e859cf3aa521a658c83c567f876.patch";
      hash = "sha256-gEtcqmxy2Til0KYLGwCxRThx9fndqdMbYam5WbzDKOo=";
    })
  ];

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

  meta = with lib; {
    description = "Samsung Smart TV WS API wrapper";
    homepage = "https://github.com/xchwarze/samsung-tv-ws-api";
    changelog = "https://github.com/xchwarze/samsung-tv-ws-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
