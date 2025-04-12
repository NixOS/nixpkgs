{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,

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
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "xchwarze";
    repo = "samsung-tv-ws-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-CU59Kg8kSEE71x6wifCKCaVFdaMftodtkrAOpD+qvWY=";
  };

  propagatedBuildInputs = [
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

  nativeCheckInputs =
    [
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
