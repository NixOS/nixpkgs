{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, poetry-core
, datetime
, httplib2
, icalendar
, python-dateutil
, pytz
}:

buildPythonPackage rec {
  pname = "icalevents";
  version = "0.1.27";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-vSYQEJFBjXUF4WwEAtkLtcO3y/am00jGS+8Vj+JMMqQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    datetime
    httplib2
    icalendar
    python-dateutil
    pytz
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Makes HTTP calls
    "test_events_url"
    "test_events_async_url"
  ];

  pythonImportsCheck = [ "icalevents" ];

  meta = with lib; {
    changelog = "https://github.com/jazzband/icalevents/releases/tag/v${version}";
    description = "Python module for iCal URL/file parsing and querying";
    homepage = "https://github.com/jazzband/icalevents";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
  };
}
