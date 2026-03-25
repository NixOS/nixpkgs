{
  # lib & utils
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,

  # build
  hatchling,
  hatch-vcs,

  # deps
  cryptography,
  matplotlib,
  numpy,
  pandas,
  platformdirs,
  pydantic,
  pyjwt,
  python-dateutil,
  rapidfuzz,
  requests,
  requests-cache,
  scipy,
  signalrcore,
  timple,
  websockets,

  # test deps
  requests-mock,
}:

buildPythonPackage rec {
  pname = "fastf1";
  version = "3.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theOehrly";
    repo = "Fast-F1";
    tag = "v${version}";
    hash = "sha256-PdkSeRQATXHr1DVu3JzUkquyi4g0uMABxm/1cEfBsC4=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    cryptography
    matplotlib
    numpy
    pandas
    platformdirs
    pydantic
    pyjwt
    python-dateutil
    rapidfuzz
    requests
    requests-cache
    scipy
    signalrcore
    timple
    websockets
  ];
  pythonRelaxDeps = [ "websockets" ];

  postPatch = ''
    # xdoctest's tests call the F1 API
    # pytest-mpl's tests render images differently in the nix sandbox than in the test reference
    substituteInPlace pytest.ini \
      --replace-fail "addopts =" "" \
      --replace-fail "  --doctest-glob=\"*.rst\"" "" \
      --replace-fail "  --xdoctest" "" \
      --replace-fail "  --mpl-baseline-path=fastf1/tests/mpl-baseline" "" \
      --replace-fail "  --mpl-results-path=mpl-results" "" \
      --replace-fail "  --mpl" ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
    requests-mock
  ];

  disabledTestPaths = [
    # nix sandbox renders images differently than the test reference
    "fastf1/tests/test_example_plots.py"

    # requires network access
    "fastf1/tests/test_api.py"
    "fastf1/tests/test_core.py"
    "fastf1/tests/test_events.py"
    "fastf1/tests/test_input_data_handling.py"
    "fastf1/tests/test_plotting.py"
    "fastf1/tests/test_livetiming.py"
    "fastf1/tests/test_mvapi.py"
    "fastf1/tests/test_laps.py"
    "fastf1/tests/test_telemetry.py"
  ];

  pythonImportsCheck = [ "fastf1" ];

  meta = {
    changelog = "https://github.com/theOehrly/Fast-F1/releases/tag/${src.tag}";
    description = "Python package for accessing and analyzing Formula 1 results, schedules, timing data and telemetry";
    homepage = "https://github.com/theOehrly/Fast-F1";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vaisriv ];
  };
}
