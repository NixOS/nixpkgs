{ lib, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-sites";
  version = "0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cbee714fdf2bfbe92e4f5055de4e6c41b64ebb32e1f96b1016c0748210928b8";
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
