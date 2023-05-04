{ lib
, buildPythonPackage
, django
#, django-json-field
, gdal
, django_nose
, django-polymorphic
, fetchFromGitHub
, geopy
, nose
, psycopg2
#, nose_progressive
, pytest-django
, pytestCheckHook
, six
}:

buildPythonPackage rec {
  pname = "django-dynamic-fixture";
  version = "3.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "paulocheque";
    repo = "django-dynamic-fixture";
    rev = "refs/tags/${version}";
    hash = "sha256-TyLOP4A5A/yoPunzWKYgREyXvfxJWcSPY43Ec8T41Tg=";
  };

  propagatedBuildInputs = [
    django_nose
    nose
#    nose_progressive
    psycopg2
    django-polymorphic
    django
    gdal
    geopy
#    django-json-field
    six
  ];

  nativeCheckInputs = [
    gdal
    pytestCheckHook
    pytest-django
  ];

  #env.DJANGO_SETTINGS = "tests.settings";


  meta = with lib; {
    description = "Django Dynamic Fixture (DDF) is a complete and simple library to create dynamic model instances for testing purposes";
    changelog = "https://github.com/paulocheque/django-dynamic-fixture/blob/${version}";
    homepage = "https://github.com/paulocheque/django-dynamic-fixture";
    license = licenses.mit;
    maintainers = with maintainers; [ der_dennisop ];
  };
}
