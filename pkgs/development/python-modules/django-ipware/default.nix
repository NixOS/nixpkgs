{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-ipware";
  version = "2.1.0";

  meta = {
    description = "A Django application to retrieve user's IP address";
    homepage = "https://github.com/un33k/django-ipware";
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "a7c7a8fd019dbdc9c357e6e582f65034e897572fc79a7e467674efa8aef9d00b";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting IPWARE_TRUSTED_PROXY_LIST, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;
}
