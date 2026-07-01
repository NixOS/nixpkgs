{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pillow,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "python-resize-image";
  version = "1.1.20";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-sFXauRnWI+zo7JUmLUvb8AbLGhDoGOmzYiHIsYhfmSI=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    pillow
    requests
  ];

  pythonImportsCheck = [
    "resizeimage"
  ];

  doCheck = false; # sdist missing test artifact

  __structuredAttrs = true;

  meta = {
    description = "Python package to easily resize images";
    homepage = "https://pypi.org/project/python-resize-image";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
