{ lib
, attrs
, boto3
, botocore
, bson
, buildPythonPackage
, cattrs
, fetchFromGitHub
, itsdangerous
, platformdirs
, poetry-core
, pymongo
, pytest-httpbin
, pytestCheckHook
, pythonOlder
, pyyaml
, redis
, requests
, requests-mock
, responses
, rich
, time-machine
, timeout-decorator
, ujson
, url-normalize
, urllib3
}:

buildPythonPackage rec {
  pname = "requests-cache";
  version = "1.1.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "requests-cache";
    repo = "requests-cache";
    rev = "refs/tags/v${version}";
    hash = "sha256-kJqy7aK67JFtmsrwMtze/wTM9qch9YYj2eUzGJRJreQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    attrs
    cattrs
    platformdirs
    requests
    urllib3
    url-normalize
  ];

  passthru.optional-dependencies = {
    dynamodb = [
      boto3
      botocore
    ];
    mongodb = [
      pymongo
    ];
    redis = [
      redis
    ];
    bson = [
      bson
    ];
    json = [
      ujson
    ];
    security = [
      itsdangerous
    ];
    yaml = [
      pyyaml
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  checkInputs = [
    # https://requests-cache.readthedocs.io/en/stable/project_info/contributing.html#integration-test-alternatives
    pytest-httpbin
    requests-mock
    responses
    rich
    timeout-decorator
    time-machine
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
    # https://requests-cache.readthedocs.io/en/stable/project_info/contributing.html#integration-test-alternatives
    export USE_PYTEST_HTTPBIN=true;
  '';

  disabledTests = [
    "test_use_temp"
  ];

  disabledTestPaths = [
    # Integration tests require local DBs
    "tests/integration/test_dynamodb.py"
    "tests/integration/test_mongodb.py"
    "tests/integration/test_redis.py"
    "tests/integration/test_upgrade.py"
  ];

  pythonImportsCheck = [
    "requests_cache"
  ];

  meta = with lib; {
    description = "Persistent cache for requests library";
    homepage = "https://github.com/reclosedev/requests-cache";
    changelog = "https://github.com/requests-cache/requests-cache/blob/v${version}/HISTORY.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
