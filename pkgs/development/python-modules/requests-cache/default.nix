{
  lib,
  attrs,
  buildPythonPackage,
  hatchling,
  boto3,
  botocore,
  cattrs,
  fetchFromGitHub,
  itsdangerous,
  platformdirs,
  psutil,
  pymongo,
  pytestCheckHook,
  pytest-rerunfailures,
  pytest-xdist,
  pyyaml,
  redis,
  requests,
  requests-mock,
  responses,
  rich,
  tenacity,
  time-machine,
  ujson,
  orjson,
  urllib3,
  url-normalize,
}:

buildPythonPackage (finalAttrs: {
  pname = "requests-cache";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "requests-cache";
    repo = "requests-cache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-t9SJ+enZHHYPRXaSrPop2hVOagE4oMnuXExO2DeNttc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    attrs
    cattrs
    platformdirs
    requests
    urllib3
    url-normalize
  ];

  optional-dependencies = {
    dynamodb = [
      boto3
      botocore
    ];
    mongodb = [ pymongo ];
    redis = [ redis ];
    security = [ itsdangerous ];
    yaml = [ pyyaml ];
    all = [
      orjson
      ujson
    ]
    ++ lib.concatAttrValues (lib.removeAttrs finalAttrs.optional-dependencies [ "all" ]);
  };

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    pytest-rerunfailures
    pytest-xdist
    requests-mock
    responses
    rich
    tenacity
    time-machine
  ];

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  enabledTestPaths = [
    # Integration tests require local DBs
    "tests/unit"
  ];

  disabledTests = [
    # Flaky
    "test_request_only_if_cached__stale_if_error__expired"
  ];

  pythonImportsCheck = [ "requests_cache" ];

  meta = {
    description = "Persistent cache for requests library";
    homepage = "https://github.com/reclosedev/requests-cache";
    changelog = "https://github.com/requests-cache/requests-cache/blob/$v{finalAttrs.version}/HISTORY.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
