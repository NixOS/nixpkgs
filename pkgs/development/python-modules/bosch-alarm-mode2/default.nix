{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
}:

buildPythonPackage rec {
  pname = "bosch-alarm-mode2";
  version = "0.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mag1024";
    repo = "bosch-alarm-mode2";
    tag = "v${version}";
    hash = "sha256-bVLwEPWpdCuLanEOAykvvVnL8C8JvOrbcVic/kV15BE=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  pythonImportsCheck = [ "bosch_alarm_mode2" ];

  meta = {
    description = "Async Python library for interacting with Bosch Alarm Panels supporting the 'Mode 2' API";
    homepage = "https://github.com/mag1024/bosch-alarm-mode2";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
