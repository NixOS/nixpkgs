{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "isodate";
  version = "0.7.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-TNGqD0PKdvSmxsApKoX0CzXsLkPjFbWfBubTIXGpU+Y=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/gweis/isodate/blob/${finalAttrs.version}/CHANGES.txt";
    description = "ISO 8601 date/time parser";
    homepage = "https://github.com/gweis/isodate/";
    license = lib.licenses.bsd0;
  };
})
