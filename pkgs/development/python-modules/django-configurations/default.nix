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
  version = "2.1";
  pname = "django-configurations";

  src = fetchPypi {
    inherit pname version;
    sha256 = "71d9acdff33aa034f0157b0b3d23629fe0cd499bf4d0b6d699b9ca0701d952e8";
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
