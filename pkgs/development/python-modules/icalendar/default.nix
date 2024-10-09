{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,
  pythonOlder,
  hatch-vcs,
  hatchling,
  backports-zoneinfo,
  python-dateutil,
  tzdata,
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage rec {
  version = "6.0.0";
  pname = "icalendar";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "collective";
    repo = "icalendar";
    rev = "refs/tags/v${version}";
    hash = "sha256-eWFDY/pNVfcUk3PfB0vXqh9swuSGtflUw44IMDJI+yI=";
  };

  patches = [
    (replaceVars ./no-dynamic-version.patch {
      inherit version;
    })
  ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    python-dateutil
    tzdata
  ] ++ lib.optionals (pythonOlder "3.9") [ backports-zoneinfo ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pytestFlagsArray = [ "src/icalendar" ];

  meta = with lib; {
    changelog = "https://github.com/collective/icalendar/blob/v${version}/CHANGES.rst";
    description = "Parser/generator of iCalendar files";
    mainProgram = "icalendar";
    homepage = "https://github.com/collective/icalendar";
    license = licenses.bsd2;
    maintainers = with maintainers; [ olcai ];
  };
}
