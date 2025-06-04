{
  # lib & utils
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

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
  version = "3.6.1";
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

  pythonImportsCheck = [ "fastf1" ];

  meta = {
    changelog = "https://github.com/theOehrly/Fast-F1/releases/tag/${src.tag}";
    description = "Python package for accessing and analyzing Formula 1 results, schedules, timing data and telemetry";
    homepage = "https://github.com/theOehrly/Fast-F1";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vaisriv ];
  };
}
