{ stdenv, buildPythonPackage, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7af56611c62a1c174aab4e862efb7fdd98296dccf76f42135f5b6851fc313c97";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting DEFAULT_INDEX_TABLESPACE, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Collection of custom storage backends for Django";
    homepage = "https://django-storages.readthedocs.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
