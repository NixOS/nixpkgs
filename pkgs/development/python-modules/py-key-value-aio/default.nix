{
  aioboto3,
  aiofile,
  aiohttp,
  aiomcache,
  anyio,
  beartype,
  buildPythonPackage,
  cachetools,
  cryptography,
  dbus-python,
  dirty-equals,
  diskcache,
  docker,
  duckdb,
  elasticsearch,
  fetchFromGitHub,
  inline-snapshot,
  keyring,
  lib,
  pathvalidate,
  pydantic,
  pymongo,
  py-key-value-shared,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  pytz,
  redis,
  types-aiobotocore-dynamodb,
  uv-build,
}:

buildPythonPackage rec {
  pname = "py-key-value-aio";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strawgate";
    repo = "py-key-value";
    tag = version;
    hash = "sha256-4ji+GzJTv1QnC5n/OaL9vR65j8BQmJsVGGnjjuulDiU=";
  };

  sourceRoot = "${src.name}/key-value/key-value-aio";

  build-system = [ uv-build ];

  dependencies = [
    beartype
    py-key-value-shared
  ];

  optional-dependencies = {
    disk = [
      diskcache
      pathvalidate
    ];
    duckdb = [
      duckdb
      pytz
    ];
    dynamodb = [
      aioboto3
      types-aiobotocore-dynamodb
    ];
    elasticsearch = [
      aiohttp
      elasticsearch
    ];
    filetree = [
      aiofile
      anyio
    ];
    keyring = [ keyring ];
    keyring-linux = [
      dbus-python
      keyring
    ];
    memcached = [ aiomcache ];
    memory = [ cachetools ];
    mongodb = [ pymongo ];
    pydantic = [ pydantic ];
    redis = [ redis ];
    wrappers-encryption = [ cryptography ];
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail "uv_build>=0.8.2,<0.9.0" "uv_build"
  '';

  nativeCheckInputs = [
    aiofile
    aiomcache
    anyio
    cachetools
    dirty-equals
    diskcache
    docker
    inline-snapshot
    pathvalidate
    pydantic
    pytestCheckHook
    pytest-asyncio
    pytest-xdist
  ];

  disabledTestPaths = [
    # Require key_value.shared_test module
    "tests/stores"
  ];

  pythonImportsCheck = [ "key_value.aio" ];

  meta = {
    description = "Async key-value store library";
    homepage = "https://strawgate.com/py-key-value/";
    changelog = "https://github.com/strawgate/py-key-value/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.amadejkastelic ];
  };
}
