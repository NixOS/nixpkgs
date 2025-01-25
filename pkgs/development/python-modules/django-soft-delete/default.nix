{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-soft-delete";
  version = "1.0.16";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zEA5jM2GnHWm1rp/Um4WxK/isMCBHCE6MY2Wu0xYp4c=";
  };

  dependencies = [ django ];

  build-system = [ setuptools ];

  # No tests
  doCheck = false;

  meta = {
    description = "Soft delete models, managers, queryset for Django";
    homepage = "https://github.com/san4ezy/django_softdelete";
    license = lib.licenses.mit;
  };
}
