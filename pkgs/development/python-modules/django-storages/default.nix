{ lib, buildPythonPackage, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.12.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0013ebe4904521e2fa28f33591a03a7210304d73363e7eadd7cdcf81c12ba003";
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
