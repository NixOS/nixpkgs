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
}:

buildPythonPackage rec {
  pname = "fakeredis";
  version = "2.30.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "dsoftwareinc";
    repo = "fakeredis-py";
    tag = "v${version}";
    hash = "sha256-SQVLuO5cA+XO7hEBph7XGlnomTcysB3ye9jZ8sy9GAI=";
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
