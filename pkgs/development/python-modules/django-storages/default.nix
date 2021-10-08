{ lib, buildPythonPackage, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b3fdb4337b1e54b8a23fe41c62d91648e26249f9fc00e882d1d09e16207aa204";
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
