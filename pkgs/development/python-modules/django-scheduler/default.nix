{ lib
, buildPythonPackage
, django
, fetchFromGitHub
, icalendar
, pytest
, pytest-django
, python
, python-dateutil
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "django-scheduler";
  version = "0.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "llazzaro";
    repo = "django-scheduler";
    rev = "refs/tags/${version}";
    hash = "sha256-dY2TPo15RRWrv7LheUNJSQl4d/HeptSMM/wQirRSI5w=";
  };

  propagatedBuildInputs = [
    django
    python-dateutil
    pytz
    icalendar
  ];

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} -m django check --settings=tests.settings
    runHook postCheck
  '';

  pythonImportsCheck = [
    "schedule"
  ];

  meta = with lib; {
    description = "A calendar app for Django";
    homepage = "https://github.com/llazzaro/django-scheduler";
    changelog = "https://github.com/llazzaro/django-scheduler/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
