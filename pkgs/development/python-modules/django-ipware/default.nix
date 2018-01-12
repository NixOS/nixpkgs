{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-ipware";
  name = "${pname}-${version}";
  version = "1.1.6";

  meta = {
    description = "A Django application to retrieve user's IP address";
    homepage = https://github.com/un33k/django-ipware;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "00zah4g2h93nbsijz556j97v9qkn9sxcia1a2wrwdwnav2fhzack";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting IPWARE_TRUSTED_PROXY_LIST, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;
}
