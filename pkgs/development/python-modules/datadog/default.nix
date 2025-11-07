{
  lib,
  stdenvNoCC,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,

  # dependencies
  requests,

  # testing
  click,
  freezegun,
  mock,
  pytest-vcr,
  pytestCheckHook,
  python-dateutil,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "datadog";
  version = "0.52.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "datadogpy";
    tag = "v${version}";
    hash = "sha256-WhfCREEuFT4b75C62KWnAyYGt4/j5tuuP8hZOHGNo10=";
  };

  build-system = [ hatchling ];

  dependencies = [ requests ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    click
    freezegun
    mock
    pytestCheckHook
    pytest-vcr
    python-dateutil
    vcrpy
  ];

  disabledTestPaths = [
    "tests/performance"
    # https://github.com/DataDog/datadogpy/issues/800
    "tests/integration/api/test_*.py"
  ];

  disabledTests = [
    "test_default_settings_set"
    # https://github.com/DataDog/datadogpy/issues/746
    "TestDogshell"

    # Flaky: test execution time against magic values
    "test_distributed"
    "test_timed"
    "test_timed_in_ms"
    "test_timed_start_stop_calls"

    # OSError: AF_UNIX path too long
    "test_socket_connection"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # https://github.com/DataDog/datadogpy/issues/880
    "test_timed_coroutine"
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    # PermissionError: [Errno 1] Operation not permitted
    "test_dedicated_uds_telemetry_dest"
  ];

  pythonImportsCheck = [ "datadog" ];

  meta = {
    description = "Datadog Python library";
    homepage = "https://github.com/DataDog/datadogpy";
    changelog = "https://github.com/DataDog/datadogpy/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
