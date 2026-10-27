{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pillow,
  python-resize-image,
}:

buildPythonPackage (finalAttrs: {
  pname = "resize-image";
  version = "0.4.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-nlJvyKSUKUNLcleBfrNH3wKh0Q97+d8laIa5POm7IeM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pillow
    python-resize-image
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "resize"
  ];

  __structuredAttrs = true;

  meta = {
    description = "Commandline utility to resize an image";
    homepage = "https://github.com/jaymu53/resize-image";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
