{ lib
, buildPythonPackage
, fetchFromGitHub
, icalendar
, lxml
, pytestCheckHook
, pythonOlder
, python
, pytz
, recurring-ical-events
, requests
, setuptools
, toPythonModule
, tzlocal
, vobject
, xandikos
}:

buildPythonPackage rec {
  pname = "caldav";
  version = "1.3.8";

  pyproject = true;
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "python-caldav";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-CZ/cqBvxQiNYJUX4BFtTjG9umf5pGPOaRcN4N1o06QM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    vobject
    lxml
    requests
    icalendar
    recurring-ical-events
    pytz
    tzlocal
  ];

  nativeCheckInputs = [
    pytestCheckHook
    (toPythonModule (xandikos.override { python3Packages = python.pkgs; }))
  ];

  pythonImportsCheck = [ "caldav" ];

  meta = with lib; {
    description = "CalDAV (RFC4791) client library";
    homepage = "https://github.com/python-caldav/caldav";
    changelog = "https://github.com/python-caldav/caldav/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ marenz dotlambda ];
  };
}
