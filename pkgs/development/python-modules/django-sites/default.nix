{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-sites";
  version = "0.10";

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
    sha256 = "f6f9ae55a05288a95567f5844222052b6b997819e174f4bde4e7c23763be6fc3";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured: Requested settings, but settings are not configured. You must either define the environment variable DJANGO_SETTINGS_MODULE or call settings.configure() before accessing settings.
  doCheck = false;
}
