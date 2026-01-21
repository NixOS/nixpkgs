{
  lib,
  buildPythonPackage,
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
  version = "7.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mfogel";
    repo = "django-timezone-field";
    tag = version;
    hash = "sha256-iOdWgLj6qzMYusfpG/aCBk3ca9Ge7Kx2p9herJtpORs=";
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

  meta = {
    description = "Django app providing database, form and serializer fields for pytz timezone objects";
    homepage = "https://github.com/mfogel/django-timezone-field";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
