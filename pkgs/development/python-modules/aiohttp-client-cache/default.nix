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
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  redis,
  url-normalize,
}:

buildPythonPackage rec {
  pname = "aiohttp-client-cache";
  version = "0.11.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "aiohttp_client_cache";
    inherit version;
    hash = "sha256-MuY60hAkD4Ik8+Encv5TrBAs8kx88Y3bhqy7n9+eS28=";
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
    pytest-aiohttp
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "aiohttp_client_cache" ];

  disabledTestPaths = [
    # Tests require running instances of the services
    "test/integration/test_dynamodb.py"
    "test/integration/test_redis.py"
    "test/integration/test_sqlite.py"
  ];

  meta = with lib; {
    description = "Async persistent cache for aiohttp requests";
    homepage = "https://github.com/requests-cache/aiohttp-client-cache";
    changelog = "https://github.com/requests-cache/aiohttp-client-cache/blob/v${version}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ seirl ];
  };
}
