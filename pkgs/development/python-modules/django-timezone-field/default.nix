{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  poetry-core,
  django,
  djangorestframework,
  pytestCheckHook,
  pytest-django,
  pytest-lazy-fixture,
  pytz,
}:

buildPythonPackage rec {
  pname = "django-timezone-field";
  version = "7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mfogel";
    repo = "django-timezone-field";
    rev = version;
    hash = "sha256-q06TuYkBA4z6tJdT3an6Z8o1i/o85XbYa1JYZBHC8lI=";
  };

  build-system = [ poetry-core ];

  dependencies = [ django ];

  pythonImportsCheck = [
    # Requested setting USE_DEPRECATED_PYTZ, but settings are not configured.
    #"timezone_field"
  ];

  preCheck = ''
    export DJANGO_SETTINGS_MODULE=tests.settings
  '';

  nativeCheckInputs = [
    djangorestframework
    pytestCheckHook
    pytest-django
    pytest-lazy-fixture
    pytz
  ];

  meta = with lib; {
    description = "Django app providing database, form and serializer fields for pytz timezone objects";
    homepage = "https://github.com/mfogel/django-timezone-field";
    license = licenses.bsd2;
    maintainers = with maintainers; [ hexa ];
  };
}
