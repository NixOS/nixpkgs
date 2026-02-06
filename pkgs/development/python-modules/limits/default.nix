{
  lib,
  buildPythonPackage,
  coredis,
  deprecated,
  fetchFromGitHub,
  flaky,
  hatchling,
  hatch-vcs,
  hiro,
  importlib-resources,
  motor,
  packaging,
  pymemcache,
  pymongo,
  pytest-asyncio,
  pytest-benchmark,
  pytest-cov-stub,
  pytest-lazy-fixtures,
  pytestCheckHook,
  redis,
  typing-extensions,
  valkey,
}:

buildPythonPackage rec {
  pname = "limits";
  version = "5.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = "limits";
    tag = version;
    hash = "sha256-JmxoFc+AWV4qLgexpAysMGRKx2Q6K6AqNoaGkWU28Ro=";
    postFetch = ''
      rm "$out/limits/_version.pyi"
    '';
  };

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "-K" ""
  '';

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    deprecated
    importlib-resources
    packaging
    typing-extensions
  ];

  optional-dependencies = {
    async-memcached = [ pymemcache ];
    async-mongodb = [ motor ];
    async-redis = [ coredis ];
    async-valkey = [ valkey ];
    memcached = [ pymemcache ];
    mongodb = [ pymongo ];
    redis = [ redis ];
    rediscluster = [ redis ];
    valkey = [ valkey ];
  };

  env = {
    # make protobuf compatible with old versions
    # https://developers.google.com/protocol-buffers/docs/news/2022-05-06#python-updates
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION = "python";
  };

  nativeCheckInputs = [
    flaky
    hiro
    pytest-asyncio
    pytest-benchmark
    pytest-cov-stub
    pytest-lazy-fixtures
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pytestFlags = [ "--benchmark-disable" ];

  disabledTests = [
    # requires docker
    "TestAsyncConcurrency"
    "TestAsyncFixedWindow"
    "TestAsyncMovingWindow"
    "TestAsyncSlidingWindow"
    "TestConcreteStorages"
    "TestConcurrency"
    "TestFixedWindow"
    "TestMovingWindow"
    "TestRedisStorage"
    "TestSlidingWindow"
  ];

  pythonImportsCheck = [ "limits" ];

  meta = {
    description = "Rate limiting using various strategies and storage backends such as redis & memcached";
    homepage = "https://github.com/alisaifee/limits";
    changelog = "https://github.com/alisaifee/limits/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sarahec ];
  };
}
