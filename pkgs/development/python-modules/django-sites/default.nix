{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-sites";
  name = "${pname}-${version}";
  version = "0.9";

  meta = {
    description = ''
      Alternative implementation of django "sites" framework
      based on settings instead of models.
    '';
    homepage = https://github.com/niwinz/django-sites;
    license = lib.licenses.bsd3;
  };

  src = fetchPypi {
    inherit pname version;
    sha256 = "05nrydk4a5a99qrxjrcnacs8nbbq5pfjikdpj4w9yn5yfayp057s";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested settings, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;
}
