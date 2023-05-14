{ lib
, appdirs
, attrs
, buildPythonPackage
, bson
, boto3
, botocore
, cattrs
, exceptiongroup
, fetchFromGitHub
, itsdangerous
, poetry-core
, pymongo
, pytestCheckHook
, pythonOlder
, pyyaml
, redis
, requests
, requests-mock
, rich
, timeout-decorator
, ujson
, urllib3
, url-normalize
}:

buildPythonPackage rec {
  pname = "requests-cache";
  version = "0.9.8";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "requests-cache";
    repo = "requests-cache";
    rev = "refs/tags/v${version}";
    hash = "sha256-Xbzbwz80xY8IDPDhZEUhmmiCFJZvSQMQ6EmE4EL7QGo=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    appdirs
    attrs
    cattrs
    exceptiongroup
    requests
    urllib3
    url-normalize
  ];

  passthru.optional-dependencies = {
    dynamodb = [
      boto3
      botocore
    ];
    mongodbo = [
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

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
    rich
    timeout-decorator
  ]
  ++ passthru.optional-dependencies.json
  ++ passthru.optional-dependencies.security;

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pytestFlagsArray = [
    # Integration tests require local DBs
    "tests/unit"
  ];

  disabledTests = [
    # Tests are flaky in the sandbox
    "test_remove_expired_responses"
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
