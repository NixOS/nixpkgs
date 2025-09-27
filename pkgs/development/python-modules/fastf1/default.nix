{
  # lib & utils
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  nix-update-script,

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
}:

buildPythonPackage rec {
  pname = "fastf1";
  version = "3.6.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "theOehrly";
    repo = "Fast-F1";
    tag = "v${version}";
    hash = "sha256-BGA84g3TrBaiRNJqJ3+vWAzVMCwU9nLMSDgs1BbcZD8=";
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

  pythonImportsCheck = [ "fastf1" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/theOehrly/Fast-F1/releases/tag/v${version}";
    description = "Python package for accessing and analyzing Formula 1 results, schedules, timing data and telemetry";
    homepage = "https://github.com/theOehrly/Fast-F1";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vaisriv ];
  };
}
