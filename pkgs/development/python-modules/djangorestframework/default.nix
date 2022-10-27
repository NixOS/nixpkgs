{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # See https://github.com/encode/django-rest-framework/issues/8608
    # and https://github.com/encode/django-rest-framework/pull/8591/
    (fetchpatch {
      name = "fix-django-collect-static.patch";
      url = "https://github.com/encode/django-rest-framework/pull/8591/commits/65943bb58deba6ee1a89fe4504f270ab1806fce6.patch";
      sha256 = "sha256-wI7EzX9tlyyXAPrJEr+/2uTg7dVY98IKgh7Cc/NZo5k=";
    })
  ];

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
