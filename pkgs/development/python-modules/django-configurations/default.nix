{ lib
, buildPythonPackage
, dj-database-url
, dj-email-url
, dj-search-url
, django
, django-cache-url
, django-discover-runner
, fetchPypi
, importlib-metadata
, mock
, pythonOlder
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "django-configurations";
  version = "2.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-IrmWTmtlfa/Ho1QQoRXSDxRRFJqCc3rcbDMew2WIgZY=";
  };

  buildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    django
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    django-discover-runner
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

  pythonImportsCheck = [
    "configurations"
  ];

  meta = with lib; {
    description = "A helper for organizing Django settings";
    homepage = "https://django-configurations.readthedocs.io/";
    license = licenses.bsd0;
    maintainers = with maintainers; [ costrouc ];
  };
}
