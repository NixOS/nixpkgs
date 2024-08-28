{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  icalendar,
  python-dateutil,
  tzdata,
  x-wr-timezone,
  pytestCheckHook,
  pytz,
  restructuredtext-lint,
  pygments,
}:

buildPythonPackage rec {
  pname = "recurring-ical-events";
  version = "3.2.0";

  disabled = pythonOlder "3.8";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "python-recurring-ical-events";
    rev = "v${version}";
    hash = "sha256-qglApMoRtMqg03HBO00k9anRquA5X9ew919QUMWIpjo=";
  };

  patches = [
    # https://github.com/niccokunzmann/python-recurring-ical-events/pull/169
    (fetchpatch2 {
      name = "make-tests-compatible-with-icalendar-v5.patch";
      url = "https://github.com/niccokunzmann/python-recurring-ical-events/commit/0bb4b4586b55978a1d154cd7abbc42eaf1cefb92.patch";
      hash = "sha256-1tG/U0ELMIwS50eolXNou0aFQBZGNjcc2Zcz1gd8rd4=";
    })
  ];

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "icalendar" ];

  dependencies = [
    icalendar
    python-dateutil
    tzdata
    x-wr-timezone
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytz
    restructuredtext-lint
    pygments
  ];

  pythonImportsCheck = [ "recurring_ical_events" ];

  meta = {
    changelog = "https://github.com/niccokunzmann/python-recurring-ical-events/blob/${src.rev}/README.rst#changelog";
    description = "Repeat ICalendar events by RRULE, RDATE and EXDATE";
    homepage = "https://github.com/niccokunzmann/python-recurring-ical-events";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
