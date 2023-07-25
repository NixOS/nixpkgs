{ lib
, buildPythonPackage
, fetchFromGitHub
, icalendar
, pytz
, python-dateutil
, x-wr-timezone
, pytestCheckHook
, restructuredtext_lint
, pygments
, tzdata
}:

buildPythonPackage rec {
  pname = "recurring-ical-events";
  version = "2.0.2";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "python-recurring-ical-events";
    rev = "v${version}";
    hash = "sha256-aM7c/HE8xLqT5wCLaCrfFn6c7FIkCJA6TTICZprAgNM=";
  };

  propagatedBuildInputs = [
    icalendar
    pytz
    python-dateutil
    x-wr-timezone
  ];

  nativeCheckInputs = [
    pytestCheckHook
    restructuredtext_lint
    pygments
    tzdata
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
