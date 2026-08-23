{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "ajpy";
  version = "0.0.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "173wm207zyi86m2ms7vscakdi4mmjqfxqsdx1gn0j9nn0gsf241h";
  };

  build-system = [ setuptools ];

  # ajpy doesn't have tests
  doCheck = false;

  meta = {
    description = "AJP package crafting library";
    homepage = "https://github.com/hypn0s/AJPy/";
    license = lib.licenses.bsd3;
  };
})
