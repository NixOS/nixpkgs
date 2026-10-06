{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "django-paintstore";
  version = "0.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-j3MmV28GGOTwONWD27VgpZjdojp1nVj4wW4uHDZ/nYs=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "paintstore" ];

  meta = {
    description = "Django app that integrates jQuery ColorPicker with the Django admin";
    homepage = "https://github.com/gsiegman/django-paintstore";
    license = lib.licenses.mit;
  };
})
