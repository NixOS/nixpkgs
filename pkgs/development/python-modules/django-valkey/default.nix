{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,

  # propagated
  backports-zstd,
  brotli,
  django,
  libvalkey,
  lz4,
  msgpack,
  msgspec,
  valkey,

  # testing
  anyio,
  pytest-django,
  pytest-mock,
  pytestCheckHook,
  redisTestHook,
}:

buildPythonPackage rec {
  pname = "django-valkey";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "django-commons";
    repo = "django-valkey";
    tag = version;
    hash = "sha256-F6BycXVBmfmtRL1C05lgg/2wehcmlqA5WWGgAIxuAsE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    django
    valkey
  ];

  optional-dependencies = {
    brotli = [ brotli ];
    libvalkey = [ libvalkey ];
    lz4 = [ lz4 ];
    msgpack = [ msgpack ];
    msgspec = [ msgspec ];
    pyzstd = [ backports-zstd ];
    zstd = [ backports-zstd ];
  };

  pythonImportsCheck = [ "django_valkey" ];

  nativeCheckInputs = [
    anyio
    pytest-django
    pytest-mock
    pytestCheckHook
    redisTestHook # contains valkey
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  disabledTestPaths = [
    # requires valkey cluster
    "tests/tests_cluster/test_backend.py"
    "tests/tests_cluster/test_cache_options.py"
    "tests/tests_cluster/test_client.py"

    # AttributeError: 'ValkeyCache' object has no attribute 'aset'
    "tests/tests_async/test_backend.py"
    # TypeError: object NoneType can't be used in 'await' expression
    "tests/tests_async/test_cache_options.py"
    # AttributeError: 'DefaultClient' object has no attribute 'aset'. Did you mean: 'hset'?
    "tests/tests_async/test_client.py"
    # AttributeError: 'ValkeyCache' object has no attribute 'ahas_key'
    "tests/tests_async/test_session.py"

    "tests/tests_async/test_requests.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Valkey backend for django";
    homepage = "https://github.com/django-commons/django-valkey";
    changelog = "https://github.com/django-commons/django-valkey/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
