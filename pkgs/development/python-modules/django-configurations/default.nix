{
  lib,
  buildPythonPackage,
  dj-database-url,
  dj-email-url,
  dj-search-url,
  django,
  django-cache-url,
  fetchPypi,
  importlib-metadata,
  mock,
  pythonOlder,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "django-configurations";
  version = "2.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-blCDdX4rvfm7eFBWdTa5apNRX2sXUD10ko/2KNsuDpQ=";
  };

  buildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ django ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

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

  meta = with lib; {
    description = "Helper for organizing Django settings";
    mainProgram = "django-cadmin";
    homepage = "https://django-configurations.readthedocs.io/";
    license = licenses.bsd0;
    maintainers = [ ];
  };
}
