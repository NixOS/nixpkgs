{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-sites";
  version = "0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f6f9ae55a05288a95567f5844222052b6b997819e174f4bde4e7c23763be6fc3";
  };
  # LICENSE file appears to be missing from pypi package, but expected by the installer
  # https://github.com/niwinz/django-sites/issues/11
  postPatch = ''
    touch LICENSE
  '';

  propagatedBuildInputs = [ django ];

  # required files for test don't seem to be included in pypi package, full source for 0.10
  # version doesn't appear to be present on github
  # https://github.com/niwinz/django-sites/issues/9
  doCheck = false;

  meta = {
    description = ''
      Alternative implementation of django "sites" framework
      based on settings instead of models.
    '';
    homepage = "https://github.com/niwinz/django-sites";
    license = lib.licenses.bsd3;
  };
}
