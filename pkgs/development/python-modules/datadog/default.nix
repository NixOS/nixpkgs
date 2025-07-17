{
  lib,
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
  version = "0.51.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DataDog";
    repo = "datadogpy";
    tag = "v${version}";
    hash = "sha256-DIuKawqOzth8XYF+M3fYm2kMeo3UbfS34/Qa4Y9V1h8=";
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

  disabledTests =
    [
      "test_default_settings_set"
      # https://github.com/DataDog/datadogpy/issues/746
      "TestDogshell"

      # Flaky: test execution time against magic values
      "test_distributed"
      "test_timed"
      "test_timed_in_ms"
      "test_timed_start_stop_calls"
    ]
    ++ lib.optionals (pythonAtLeast "3.13") [
      # https://github.com/DataDog/datadogpy/issues/880
      "test_timed_coroutine"
    ];

  pythonImportsCheck = [ "datadog" ];

  meta = {
    description = "Datadog Python library";
    homepage = "https://github.com/DataDog/datadogpy";
    changelog = "https://github.com/DataDog/datadogpy/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.sarahec ];
  };
}
