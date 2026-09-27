{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  wheel,
}:

buildPythonPackage (finalAttrs: {

  pname = "Represent";

  version = "2.1";

  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Cy0BXBTnums7Xmp7oTGpUgE/6UQzmsU4dkznKKddvKw=";
  };

  build-system = [
    setuptools
    wheel
  ];

  meta = {
    changelog = "https://github.com/RazerM/represent/blob/master/CHANGELOG.md";
    description = "Python libary to generate __repr__";
    homepage = "https://represent.readthedocs.io/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eidoom ];
  };

})
