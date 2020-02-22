{ stdenv, buildPythonPackage, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "148y2hyx1l4pfbqpq8hgq95fw8bhfbblwd3m5xwnhw6frcirk7m5";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting DEFAULT_INDEX_TABLESPACE, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Collection of custom storage backends for Django";
    homepage = https://django-storages.readthedocs.io;
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
