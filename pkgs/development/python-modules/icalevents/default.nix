{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  pytestCheckHook,
  poetry-core,
  httplib2,
  icalendar,
  python-dateutil,
  pytz,
}:

buildPythonPackage rec {
  pname = "icalevents";
  version = "0.1.28";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "jazzband";
    repo = "icalevents";
    rev = "refs/tags/v${version}";
    hash = "sha256-JX4j2CsEY/bHrD7Rb9ru3C4T2e94mpC369nDN6Cv/I0=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    httplib2
    icalendar
    python-dateutil
    pytz
  ];

  pythonRelaxDeps = [
    "httplib2"
    "icalendar"
    "pytz"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

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
