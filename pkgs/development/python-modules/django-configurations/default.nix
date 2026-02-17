{
  lib,
  buildPythonPackage,
  dj-database-url,
  dj-email-url,
  dj-search-url,
  django,
  django-cache-url,
  fetchPypi,
  mock,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-configurations";
  version = "2.5.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-blCDdX4rvfm7eFBWdTa5apNRX2sXUD10ko/2KNsuDpQ=";
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ django ];

  nativeCheckInputs = [
    mock
    dj-database-url
    dj-email-url
    dj-search-url
    django-cache-url
  ];

  checkPhase = ''
    export PYTHONPATH=.:$PYTHONPATH
    export DJANGO_SETTINGS_MODULE="tests.settings.main"
    export DJANGO_CONFIGURATION="Test"
    ${django}/bin/django-admin.py test
  '';

  # django.core.exceptions.ImproperlyConfigured: django-configurations settings importer wasn't correctly installed
  doCheck = false;

  pythonImportsCheck = [ "configurations" ];

  meta = {
    description = "Helper for organizing Django settings";
    mainProgram = "django-cadmin";
    homepage = "https://django-configurations.readthedocs.io/";
    license = lib.licenses.bsd0;
    maintainers = [ ];
  };
}
