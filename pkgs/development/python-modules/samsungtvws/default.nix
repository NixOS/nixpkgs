{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27

# propagates:
, requests
, websocket-client

# extras: async
, aiohttp
, websockets

# extras: encrypted
, cryptography
, py3rijndael

# tests
, aioresponses
, pytest-asyncio
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "samsungtvws";
  version = "2.5.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "xchwarze";
    repo = "samsung-tv-ws-api";
    rev = "v${version}";
    hash = "sha256-AimG5tyTRBETpivC2BwCuoR4o7y98YT6u5sogJlcmoo=";
  };

  propagatedBuildInputs = [
    requests
    websocket-client
  ];

  passthru.optional-dependencies = {
    async = [
      aiohttp
      websockets
    ];
    encrypted = [
      cryptography
      py3rijndael
    ];
  };

  checkInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ]
  ++ passthru.optional-dependencies.async
  ++ passthru.optional-dependencies.encrypted;

  pythonImportsCheck = [ "samsungtvws" ];

  meta = with lib; {
    description = "Samsung Smart TV WS API wrapper";
    homepage = "https://github.com/xchwarze/samsung-tv-ws-api";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
