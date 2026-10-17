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
  hatchling,
  pytest-asyncio,
  pytest-aiohttp,
  pytestCheckHook,
  redis,
  url-normalize,
}:

buildPythonPackage rec {
  pname = "aiohttp-client-cache";
  version = "0.15.0";
  pyproject = true;

  src = fetchPypi {
    pname = "aiohttp_client_cache";
    inherit version;
    hash = "sha256-Jk+n1pvNsuT+mZTn9Bq17sfLuipfXiYNRE0AL5Ym43Q=";
  };

  build-system = [ hatchling ];

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
  ++ lib.concatAttrValues optional-dependencies;

  pytestFlags = [ "--asyncio-mode=auto" ];

  pythonImportsCheck = [ "aiohttp_client_cache" ];

  disabledTestPaths = [
    # Tests require running instances of the services
    "test/integration/*"
  ];

  meta = {
    description = "Async persistent cache for aiohttp requests";
    homepage = "https://github.com/requests-cache/aiohttp-client-cache";
    changelog = "https://github.com/requests-cache/aiohttp-client-cache/blob/v${version}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seirl ];
  };
}
