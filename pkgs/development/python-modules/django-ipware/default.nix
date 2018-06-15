{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-ipware";
  name = "${pname}-${version}";
  version = "2.0.2";

  meta = {
    description = "A Django application to retrieve user's IP address";
    homepage = https://github.com/un33k/django-ipware;
    license = lib.licenses.mit;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "abf2bfbf0ec6c04679372a55c25889c9b08f55ec404bca3dfc08f3cf6c832a11";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested setting IPWARE_TRUSTED_PROXY_LIST, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;
}
