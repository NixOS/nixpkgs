{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hypothesis,
  jsonpath-ng,
  lupa,
  hatchling,
  pyprobables,
  pytest-asyncio_0,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  redis,
  redisTestHook,
  sortedcontainers,
  valkey,
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "2.32.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dsoftwareinc";
    repo = "fakeredis-py";
    tag = "v${version}";
    hash = "sha256-esouWM32qe4iO5AcRC0HuUF+lwEDHnyXoknwqsZhr+o=";
  };

  build-system = [ hatchling ];

  dependencies = [
    redis
    sortedcontainers
    valkey
  ];

  optional-dependencies = {
    lua = [ lupa ];
    json = [ jsonpath-ng ];
    bf = [ pyprobables ];
    cf = [ pyprobables ];
    probabilistic = [ pyprobables ];
  };

  nativeCheckInputs = [
    hypothesis
    pytest-asyncio_0
    pytest-mock
    pytestCheckHook
    redisTestHook
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

  meta = with lib; {
    description = "Fake implementation of Redis API";
    homepage = "https://github.com/dsoftwareinc/fakeredis-py";
    changelog = "https://github.com/cunla/fakeredis-py/releases/tag/${src.tag}";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
