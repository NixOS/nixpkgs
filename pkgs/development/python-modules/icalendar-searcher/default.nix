{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  icalendar,
  lib,
  pyicu,
  pytestCheckHook,
  recurring-ical-events,
}:

buildPythonPackage rec {
  pname = "icalendar-searcher";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "icalendar-searcher";
    tag = "v${version}";
    hash = "sha256-FNrc+SQar8vftn2zGtMtQW5Tb9KwELSozt8oO4ogxn0=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    icalendar
    recurring-ical-events
  ];

  optional-dependencies = {
    collation = [ pyicu ];
  };

  pythonImportsCheck = [ "icalendar_searcher" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  meta = {
    changelog = "https://github.com/python-caldav/icalendar-searcher/blob/${src.tag}/CHANGELOG.md";
    description = "Search, filter and sort iCalendar components";
    homepage = "https://github.com/python-caldav/icalendar-searcher";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
