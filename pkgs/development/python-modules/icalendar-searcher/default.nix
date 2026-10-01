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
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "icalendar-searcher";
    tag = "v${version}";
    hash = "sha256-HkiKy38B5+i6Lb+0Teu/YqvrE1gqy/x3u1GRUWAHNes=";
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
