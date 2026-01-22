{
  lib,
  aetcd,
  buildPythonPackage,
  coredis,
  deprecated,
  etcd3,
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
    hash = "sha256-kghfF2ihEvyMPEGO1m9BquCdeBsYRoPyIljdLL1hToQ=";
  };

  patches = [
    ./only-test-in-memory.patch
  ];

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
    redis = [ redis ];
    rediscluster = [ redis ];
    memcached = [ pymemcache ];
    mongodb = [ pymongo ];
    etcd = [ etcd3 ];
    async-redis = [ coredis ];
    # async-memcached = [
    #   emcache  # Missing module
    # ];
    async-mongodb = [ motor ];
    async-etcd = [ aetcd ];
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
    "test_moving_window_memcached"
    # Flaky: compares time to magic value
    "test_sliding_window_counter_previous_window"
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
