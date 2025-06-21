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
}: let
  websockets13 = websockets.overrideDerivation (oldAttrs: {
    src = fetchFromGitHub {
      owner = "aaugustin";
      repo = "websockets";
      tag = "13.1";
      hash = "sha256-Y0HDZw+H7l8+ywLLzFk66GNDCI0uWOZYypG86ozLo7c";
    };
  });
in
buildPythonPackage {
  pname = "fastf1";
  version = "3.5.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "theOehrly";
    repo = "Fast-F1";
    rev = "bc032923c5ccb5ccb693fc238a0949d8afaae139";
    hash = "sha256-lXXTD++mnG1iMP2r6y7czf9hXtC4niDiCVMitPGHQ5c";
  };

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
    pandas
    python-dateutil
    rapidfuzz
    requests
    requests-cache
    scipy
    timple
    websockets13
  ];

  pythonImportsCheck = [ "fastf1" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/theOehrly/Fast-F1/releases/tag/v${version}";
    description = "Python package for accessing and analyzing Formula 1 results, schedules, timing data and telemetry";
    homepage = "https://github.com/theOehrly/Fast-F1";
    license = licenses.mit;
    maintainers = with maintainers; [ vaisriv ];
  };
}
