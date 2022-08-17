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
  version = "0.9.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "reclosedev";
    repo = "requests-cache";
    rev = "v${version}";
    hash = "sha256-oVEai7SceZUdsGYlOOMxO6DxMZMVsvqXvEu0cHzq7lY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  postPatch = ''
    #
    # There is no functional reason why attrs (and cattrs) need to be
    # restricted, but the versions are in flux right now. Please read
    # and follow the following issue for the latest:
    #
    #   https://github.com/requests-cache/requests-cache/issues/675
    #
    # This can be removed once that issue is resolved, or if the new
    # major version is released.
    #
    substituteInPlace pyproject.toml \
      --replace 'attrs         = "^21.2"' 'attrs         = ">=21.2"'
  '';

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

  checkInputs = [
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
