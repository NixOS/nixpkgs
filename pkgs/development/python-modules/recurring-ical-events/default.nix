{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  git,
  hatch-vcs,
  hatchling,
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
  version = "3.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "python-recurring-ical-events";
    tag = "v${version}";
    hash = "sha256-34j4N8ICQzcW3/YQ1Yk8TKrcBlqg0fbx/5PnJ+fZjfE=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'dynamic = ["urls", "version"]' 'version = "${version}"'
  '';

  build-system = [
    hatch-vcs
    hatchling
  ];

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
    changelog = "https://github.com/niccokunzmann/python-recurring-ical-events/blob/${src.tag}/docs/changelog.md";
    description = "Repeat ICalendar events by RRULE, RDATE and EXDATE";
    homepage = "https://github.com/niccokunzmann/python-recurring-ical-events";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
