{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, setuptools
, icalendar
, pytz
, python-dateutil
, x-wr-timezone
, pytestCheckHook
, restructuredtext-lint
, pygments
, tzdata
}:

buildPythonPackage rec {
  pname = "recurring-ical-events";
  version = "2.1.2";

  disabled = pythonOlder "3.7";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "python-recurring-ical-events";
    rev = "v${version}";
    hash = "sha256-6qFUw5xfZvDuM/UBEGtoiHON15/6oq1S8H0Z1qk3k8s=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    icalendar
    pytz
    python-dateutil
    x-wr-timezone
  ];

  nativeCheckInputs = [
    pytestCheckHook
    restructuredtext-lint
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
