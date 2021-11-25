{ lib
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
, setuptools-scm
}:

buildPythonPackage rec {
  version = "2.3.1";
  pname = "django-configurations";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e2ca25530e184f0ee3b7f5ae69563461a93a8914493306ee0bf6d71e7d8ad1d0";
  };

  buildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ six ];
  checkInputs = [ django-discover-runner mock dj-database-url dj-email-url dj-search-url django-cache-url ];

  checkPhase = ''
    export PYTHONPATH=.:$PYTHONPATH
    export DJANGO_SETTINGS_MODULE="tests.settings.main"
    export DJANGO_CONFIGURATION="Test"
    ${django}/bin/django-admin.py test
  '';

  # django.core.exceptions.ImproperlyConfigured: django-configurations settings importer wasn't correctly installed
  doCheck = false;

  meta = with lib; {
    homepage = "https://django-configurations.readthedocs.io/";
    description = "A helper for organizing Django settings";
    license = licenses.bsd0;
    maintainers = [ maintainers.costrouc ];
  };
}
