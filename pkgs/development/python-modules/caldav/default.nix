{ lib
, buildPythonPackage
, fetchFromGitHub
, icalendar
, lxml
, pytestCheckHook
, pytz
, recurring-ical-events
, requests
, six
, tzlocal
, vobject
}:

buildPythonPackage rec {
  pname = "caldav";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1BGy4h0TpeiUNtUnj/BiGSfH4T9YXP8YGJ1+4UsRGug=";
  };

  propagatedBuildInputs = [
    vobject
    lxml
    requests
    six
    icalendar
    recurring-ical-events
  ];

  checkInputs = [
    pytestCheckHook
    tzlocal
    pytz
  ];

  # xandikos and radicale are only optional test dependencies, not available for python3
  postPatch = ''
    substituteInPlace setup.py \
      --replace xandikos "" \
      --replace radicale ""
  '';

  pythonImportsCheck = [ "caldav" ];

  meta = with lib; {
    description = "CalDAV (RFC4791) client library";
    homepage = "https://github.com/python-caldav/caldav";
    license = licenses.asl20;
    maintainers = with maintainers; [ marenz dotlambda ];
  };
}
