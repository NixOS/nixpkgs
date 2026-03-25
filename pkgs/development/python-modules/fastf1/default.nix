{
  # lib & utils
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,

  # build
  hatchling,
  hatch-vcs,

  # deps
  matplotlib,
  numpy,
  pandas,
  python-dateutil,
  rapidfuzz,
  requests,
  requests-cache,
  scipy,
  timple,
  websockets,

  # test deps
  requests-mock,
}:

buildPythonPackage rec {
  pname = "fastf1";
  version = "3.6.1"; # not bumping to 3.7.0 (or newer), as 3.7.0 introduces a new requirement (signalrcore) which is not available in nixpkgs
  pyproject = true;

  src = fetchFromGitHub {
    owner = "theOehrly";
    repo = "Fast-F1";
    tag = "v${version}";
    hash = "sha256-cGSQEm+8KHyBvX5oSJDgSpaMjX//oF3fBbrbpk1uGPY=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    matplotlib
    numpy
    pandas
    python-dateutil
    rapidfuzz
    requests
    requests-cache
    scipy
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
  ];

  disabledTests = [
    # requires network access
    "test_no_timing_app_data"

    # incompatible with pandas 2.x; NaT handling changed for timedelta columns
    # upstream issue with fastf1
    "test_calculated_quali_results"
    "test_quali_q3_cancelled"
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
