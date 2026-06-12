{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "easydict";
  version = "1.13";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-sRNd7bxByAEOK8H3fsl0TH+qQrzhoch0FnkUSdbId4A=";
  };

  build-system = [
    setuptools
  ];

  doCheck = false; # No tests in archive

  pythonImportsCheck = [ "easydict" ];

  meta = {
    description = "Access dict values as attributes (works recursively)";
    homepage = "https://github.com/makinacorpus/easydict";
    changelog = "https://github.com/makinacorpus/easydict/releases/tag/${finalAttrs.version}";
    license = lib.licenses.lgpl3;
    hasNoMaintainersButDependents = true;
  };
})
