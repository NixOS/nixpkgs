{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  zope-testing,
}:

buildPythonPackage (finalAttrs: {
  pname = "manuel";
  version = "1.13.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-XWMSDej6bZJ3gLaa4oqj6dFmmxCvPTJ4Xz+6EaW+iFo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ zope-testing ];

  meta = {
    description = "Documentation builder";
    homepage = "https://pypi.org/project/manuel/";
    license = lib.licenses.zpl20;
  };
})
