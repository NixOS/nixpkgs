{ lib
, buildPythonPackage
, fetchFromGitHub
, coreapi
, django
, django-guardian
, pythonOlder
, pytest-django
, pytestCheckHook
, pytz
, pyyaml
, uritemplate
}:

buildPythonPackage rec {
  pname = "djangorestframework";
  version = "3.13.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = "django-rest-framework";
    rev = version;
    sha256 = "sha256-XmX6DZBZYzVCe72GERplAWt5jIjV/cYercZGb0pYjoc=";
  };


  propagatedBuildInputs = [
    django
    pytz
  ];

  checkInputs = [
    pytest-django
    pytestCheckHook

    # optional tests
    coreapi
    django-guardian
    pyyaml
    uritemplate
  ];

  pythonImportsCheck = [ "rest_framework" ];

  meta = with lib; {
    description = "Web APIs for Django, made easy";
    homepage = "https://www.django-rest-framework.org/";
    maintainers = with maintainers; [ desiderius SuperSandro2000 ];
    license = licenses.bsd2;
  };
}
