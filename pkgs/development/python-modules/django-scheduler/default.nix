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
  version = "1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "llazzaro";
    repo = "django-scheduler";
    rev = "refs/heads/develop";
    hash = "sha256-dt/6Ktyc24qgodvOwUzAC4UeUyOr0RG6tBJ7jIiol5I=";
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
    changelog = "https://github.com/llazzaro/django-scheduler/releases/tag/v${version}-alpha";
    license = licenses.bsd3;
    maintainers = with maintainers; [ derdennisop ];
  };
}
