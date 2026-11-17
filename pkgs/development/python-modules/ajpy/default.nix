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
    hash = "sha256-MBDh9APWJgnsC71p3B2WtZLYpmJ6H11FNSj6f4CofJw=";
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
