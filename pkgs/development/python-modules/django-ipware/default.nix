{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-ipware";
  name = "${pname}-${version}";
  version = "2.0.1";

  meta = {
    description = "A Django application to retrieve user's IP address";
    homepage = https://github.com/un33k/django-ipware;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "3fba8821298c8533ce5609debf31dc8a22f228c50e100f42d97637a9f9357d43";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting IPWARE_TRUSTED_PROXY_LIST, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;
}
