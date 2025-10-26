{
  lib,
  aioboto3,
  aiobotocore,
  aiofiles,
  aiohttp,
  aiosqlite,
  attrs,
  buildPythonPackage,
  faker,
  fetchPypi,
  itsdangerous,
  motor,
  poetry-core,
  pytest-asyncio,
  pytest-aiohttp,
  pytestCheckHook,
  redis,
  url-normalize,
}:

buildPythonPackage rec {
  pname = "aiohttp-client-cache";
  version = "0.14.1";
  pyproject = true;

  src = fetchPypi {
    pname = "aiohttp_client_cache";
    inherit version;
    hash = "sha256-r1VW9xmBSsoC22OEJxBpzsame+Maa32UN+CmqZgKSU8=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    attrs
    itsdangerous
    url-normalize
  ];

  optional-dependencies = {
    all = [
      aioboto3
      aiobotocore
      aiofiles
      aiosqlite
      motor
      redis
    ];
    dynamodb = [
      aioboto3
      aiobotocore
    ];
    filesystem = [
      aiofiles
      aiosqlite
    ];
    mongodb = [ motor ];
    redis = [ redis ];
    sqlite = [ aiosqlite ];
  };

  nativeCheckInputs = [
    faker
    pytest-asyncio
    pytest-aiohttp
    pytestCheckHook
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pytestFlags = [ "--asyncio-mode=auto" ];

  pythonImportsCheck = [ "aiohttp_client_cache" ];

  disabledTestPaths = [
    # Tests require running instances of the services
    "test/integration/*"
  ];

  meta = with lib; {
    description = "Async persistent cache for aiohttp requests";
    homepage = "https://github.com/requests-cache/aiohttp-client-cache";
    changelog = "https://github.com/requests-cache/aiohttp-client-cache/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ seirl ];
  };
}
