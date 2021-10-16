{ lib, buildPythonPackage, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.12.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cb079981e2e4fe16d7f41000913225140dc334a84f5b7c5e4fcc6b7e6a028222";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting DEFAULT_INDEX_TABLESPACE, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;

  meta = with lib; {
    description = "Collection of custom storage backends for Django";
    homepage = "https://django-storages.readthedocs.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
