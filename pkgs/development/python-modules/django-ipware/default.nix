{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-ipware";
  version = "3.0.2";

  meta = {
    description = "A Django application to retrieve user's IP address";
    homepage = "https://github.com/un33k/django-ipware";
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7df8e1410a8e5d6b1fbae58728402ea59950f043c3582e033e866f0f0cf5e94";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting IPWARE_TRUSTED_PROXY_LIST, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;
}
