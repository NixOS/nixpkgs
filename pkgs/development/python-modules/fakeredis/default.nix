{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  jsonpath-ng,
  lupa,
  hatchling,
  pyprobables,
  pytest-asyncio,
  pytest-mock,
  pytestCheckHook,
  redis,
  redisTestHook,
  sortedcontainers,
  valkey,
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "2.33.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dsoftwareinc";
    repo = "fakeredis-py";
    tag = "v${version}";
    hash = "sha256-uvbvrziVdoa/ip8MbZG8GcpN1FoINxUV+SDVRmg78Qs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    redis
    sortedcontainers
  ];

  optional-dependencies = {
    lua = [ lupa ];
    json = [ jsonpath-ng ];
    bf = [ pyprobables ];
    cf = [ pyprobables ];
    probabilistic = [ pyprobables ];
    valkey = [ valkey ];
  };

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio
    pytest-mock
    pytestCheckHook
    redisTestHook
    valkey
  ];

  pythonImportsCheck = [ "fakeredis" ];

  disabledTestMarks = [ "slow" ];

  disabledTests = [
    "test_init_args" # AttributeError: module 'fakeredis' has no attribute 'FakeValkey'
    "test_async_init_kwargs" # AttributeError: module 'fakeredis' has no attribute 'FakeAsyncValkey'"

    # redis.exceptions.ResponseError: unknown command 'evalsha'
    "test_async_lock"

    # AssertionError: assert [0, b'1'] == [0, 1.0]
    "test_zrank_redis7_2"
    "test_zrevrank_redis7_2"

    # KeyError: 'tot-mem'
    "test_acl_log_auth_exist"
    "test_acl_log_invalid_channel"
    "test_acl_log_invalid_key"
    "test_client_id"
    "test_client_info"
    "test_client_list"
  ];

  preCheck = ''
    redisTestPort=6390
  '';

  meta = {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/dsoftwareinc/fakeredis-py";
    changelog = "https://github.com/cunla/fakeredis-py/releases/tag/${src.tag}";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
