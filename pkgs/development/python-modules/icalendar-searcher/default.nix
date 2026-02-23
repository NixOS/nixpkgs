{
  buildPythonPackage,
  fetchFromGitHub,
  icalendar,
  lib,
  poetry-core,
  poetry-dynamic-versioning,
  pyicu,
  pytestCheckHook,
  recurring-ical-events,
}:

buildPythonPackage rec {
  pname = "icalendar-searcher";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = "icalendar-searcher";
    tag = "v${version}";
    hash = "sha256-CHW1++VHoTfNw5GkRfDDTERZGA/RJxc8iME8OPx1q/o=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
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
