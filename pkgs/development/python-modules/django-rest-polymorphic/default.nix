{ lib
, buildPythonPackage
, fetchFromGitHub
, django
, django-polymorphic
, djangorestframework
, pytest-django
, pytest-mock
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "django-rest-polymorphic";
  version = "0.1.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "apirobot";
    repo = "django-rest-polymorphic";
     # https://github.com/denisorehovsky/django-rest-polymorphic/issues/42
    rev = "9d920eb91ef13144094426f9ebc0ca80247c0fe3";
    hash = "sha256-k7Cl2QYkaGOZaTo8v5Wg9Wqh8x0WC5i9Sggqj8eeECY=";
  };

  propagatedBuildInputs = [
    django
    django-polymorphic
    djangorestframework
    six
  ];

  nativeCheckInputs = [
    pytest-django
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rest_polymorphic" ];

  meta = with lib; {
    description = "Polymorphic serializers for Django REST Framework";
    homepage = "https://github.com/apirobot/django-rest-polymorphic";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
