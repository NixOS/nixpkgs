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
  version = "2.32.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dsoftwareinc";
    repo = "fakeredis-py";
    tag = "v${version}";
    hash = "sha256-66lTCnN6M818FvEkPMRacmgrmBOYCIgbgxjqkhxsir8=";
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
