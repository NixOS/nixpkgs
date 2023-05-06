{ lib
, buildPythonPackage
, fetchFromGitHub
, icalendar
, lxml
, pytestCheckHook
, pythonOlder
, pytz
, recurring-ical-events
, requests
, tzlocal
, vobject
}:

buildPythonPackage rec {
  pname = "caldav";
  version = "1.2.1";

  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-nA7if28M4rDZwlF+ga/1FqD838zeu0OblrPUer3w3qM=";
  };

  propagatedBuildInputs = [
    vobject
    lxml
    requests
    icalendar
    recurring-ical-events
  ];

  nativeCheckInputs = [
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
    changelog = "https://github.com/python-caldav/caldav/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ marenz dotlambda ];
  };
}
