{ stdenv
, buildPythonPackage
, fetchPypi
, django-discover-runner
, mock
, dj-database-url
, dj-email-url
, dj-search-url
, django-cache-url
, six
, django
}:

buildPythonPackage rec {
  version = "2.2";
  pname = "django-configurations";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e3bcea1355ac50a4c9f854f751d214cb17e5f8adf18405a4488d0a1e8945915";
  };

  checkInputs = [ django-discover-runner mock dj-database-url dj-email-url dj-search-url django-cache-url six ];

  checkPhase = ''
    export PYTHONPATH=.:$PYTHONPATH
    export DJANGO_SETTINGS_MODULE="tests.settings.main"
    export DJANGO_CONFIGURATION="Test"
    ${django}/bin/django-admin.py test
  '';

  # django.core.exceptions.ImproperlyConfigured: django-configurations settings importer wasn't correctly installed
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = https://django-configurations.readthedocs.io/;
    description = "A helper for organizing Django settings";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
