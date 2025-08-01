{
  lib,
  aetcd,
  buildPythonPackage,
  coredis,
  deprecated,
  etcd3,
  fetchFromGitHub,
  flaky,
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
  pythonOlder,
  redis,
  setuptools,
  typing-extensions,
  valkey,
}:

buildPythonPackage rec {
  pname = "limits";
  version = "5.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = "limits";
    tag = version;
    # Upstream uses versioneer, which relies on git attributes substitution.
    # This leads to non-reproducible archives on github. Remove the substituted
    # file here, and recreate it later based on our version info.
    hash = "sha256-EHLqkd5Muazr52/oYaLklFVvF+AzJWGbFaaIG+T0ulE=";
    postFetch = ''
      rm "$out/limits/_version.py"
    '';
  };

  patches = [
    ./only-test-in-memory.patch
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "-K" ""

    substituteInPlace setup.py \
      --replace-fail "versioneer.get_version()" "'${version}'"

    # Recreate _version.py, deleted at fetch time due to non-reproducibility.
    echo 'def get_versions(): return {"version": "${version}"}' > limits/_version.py
  '';

  build-system = [ setuptools ];

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
  ++ lib.flatten (lib.attrValues optional-dependencies);

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
