{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, icalendar
, pytz
, python-dateutil
, x-wr-timezone
, restructuredtext_lint
, pygments
, tzdata
}:

buildPythonPackage rec {
  pname = "recurring-ical-events";
  version = "1.0.3b0";

  src = fetchFromGitHub {
    owner = "niccokunzmann";
    repo = "python-recurring-ical-events";
    rev = "v${version}";
    sha256 = "0xv28pkgal4s49imm30x1ll5pbqw83v0cw78bspl38kfwpgm8265";
  };

  propagatedBuildInputs = [
    icalendar
    pytz
    python-dateutil
    x-wr-timezone
  ];

  pythonImportsCheck = [ "recurring_ical_events" ];

  checkInputs = [
    pytestCheckHook
    restructuredtext_lint
    pygments
    tzdata
  ];

  meta = {
    description = "Python library for recurrence of ical events based on icalendar";
    homepage = "https://github.com/niccokunzmann/python-recurring-ical-events";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ swflint ];
  };

}
