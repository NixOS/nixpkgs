{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  beartype,
  py-key-value-shared,

  # optional-dependencies
  # memory
  cachetools,
  # disk
  diskcache,
  pathvalidate,
  # filetree
  aiofile,
  anyio,
  # redis
  redis,
  # mongodb
  pymongo,
  # valkey
  # valkey-glide,
  # vault
  hvac,
  # types-hvac,
  # memcached
  aiomcache,
  # elasticsearch
  elasticsearch,
  aiohttp,
  # dynamodb
  aioboto3,
  types-aiobotocore-dynamodb,
  # keyring
  keyring,
  # keyring-linux
  dbus-python,
  # pydantic
  pydantic,
  # rocksdb
  rocksdict,
  # duckdb
  duckdb,
  pytz,
  # wrappers-encryption
  cryptography,

  # tests
  bson,
  docker,
  dirty-equals,
  inline-snapshot,
  py-key-value-shared-test,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-key-value-aio";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "strawgate";
    repo = "py-key-value";
    tag = finalAttrs.version;
    hash = "sha256-4ji+GzJTv1QnC5n/OaL9vR65j8BQmJsVGGnjjuulDiU=";
  };

  sourceRoot = "${finalAttrs.src.name}/key-value/key-value-aio";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        "uv_build>=0.8.2,<0.9.0" \
        "uv_build"
  ''
  # Tests fail when using pytest-xdist ('Worker crashes')
  # https://github.com/strawgate/py-key-value/issues/266
  + ''
    substituteInPlace pyproject.toml \
      --replace-fail \
        '"-n=auto",' \
        ""
    substituteInPlace pyproject.toml \
      --replace-fail \
        '"--dist=loadfile",' \
        ""
  '';

  build-system = [
    uv-build
  ];

  dependencies = [
    beartype
    py-key-value-shared
  ];

  optional-dependencies = {
    memory = [
      cachetools
    ];
    disk = [
      diskcache
      pathvalidate
    ];
    filetree = [
      aiofile
      anyio
    ];
    redis = [
      redis
    ];
    mongodb = [
      pymongo
    ];
    valkey = [
      # valkey-glide (unpackaged)
    ];
    vault = [
      hvac
      # types-hvac (unpackaged)
    ];
    memcached = [
      aiomcache
    ];
    elasticsearch = [
      elasticsearch
      aiohttp
    ];
    dynamodb = [
      aioboto3
      types-aiobotocore-dynamodb
    ];
    keyring = [
      keyring
    ];
    keyring-linux = [
      keyring
      dbus-python
    ];
    pydantic = [
      pydantic
    ];
    rocksdb = [
      rocksdict
    ];
    duckdb = [
      duckdb
      pytz
    ];
    wrappers-encryption = [
      cryptography
    ];
  };

  pythonImportsCheck = [ "key_value.aio" ];

  nativeCheckInputs = [
    bson
    dirty-equals
    docker
    duckdb
    inline-snapshot
    py-key-value-shared-test
    pytest-asyncio
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.disk
  ++ finalAttrs.passthru.optional-dependencies.dynamodb
  ++ finalAttrs.passthru.optional-dependencies.elasticsearch
  ++ finalAttrs.passthru.optional-dependencies.filetree
  ++ finalAttrs.passthru.optional-dependencies.keyring
  ++ finalAttrs.passthru.optional-dependencies.memcached
  ++ finalAttrs.passthru.optional-dependencies.memory
  ++ finalAttrs.passthru.optional-dependencies.mongodb
  ++ finalAttrs.passthru.optional-dependencies.pydantic
  ++ finalAttrs.passthru.optional-dependencies.redis
  ++ finalAttrs.passthru.optional-dependencies.rocksdb
  ++ finalAttrs.passthru.optional-dependencies.wrappers-encryption;

  disabledTestPaths = [
    # ModuleNotFoundError: No module named 'bson.codec_options'
    "tests/stores/mongodb/test_mongodb.py"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # keyring.errors.PasswordSetError: Can't store password on keychain: (-61, 'Unknown Error')
    "tests/stores/keyring/test_keyring.py"

    # Worker crashes
    # https://github.com/strawgate/py-key-value/issues/266
    "tests/stores/rocksdb/test_rocksdb.py"
  ];

  meta = {
    description = "Async Key-Value";
    homepage = "https://github.com/strawgate/py-key-value/tree/main/key-value/key-value-aio";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
