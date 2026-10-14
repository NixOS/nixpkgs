{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  beartype,
  typing-extensions,

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
  dirty-equals,
  inline-snapshot,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "py-key-value-aio";
  version = "0.4.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "strawgate";
    repo = "py-key-value";
    tag = finalAttrs.version;
    hash = "sha256-N+bqgKkSVGEKW/BEWgcFiHEuFjGbgIn/j33Vd0YoJ7s=";
  };

  # Tests fail when using pytest-xdist ('Worker crashes')
  # https://github.com/strawgate/py-key-value/issues/266
  postPatch = ''
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
    typing-extensions
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

  # Prevent Beartype's import hook from writing non-reproducible bytecode.
  env.PYTHONDONTWRITEBYTECODE = 1;

  pythonImportsCheck = [ "key_value.aio" ];

  nativeCheckInputs = [
    dirty-equals
    inline-snapshot
    pytest-asyncio
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.filetree
  ++ finalAttrs.passthru.optional-dependencies.memory
  ++ finalAttrs.passthru.optional-dependencies.pydantic;

  pytestFlags = [
    "tests/stores/filetree"
    "tests/stores/memory"
  ];

  meta = {
    description = "Async Key-Value";
    homepage = "https://github.com/strawgate/py-key-value";
    changelog = "https://github.com/strawgate/py-key-value/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
