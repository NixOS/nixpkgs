{
  lib,
  buildPythonPackage,
  fetchPypi,
  python,
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

  # https://github.com/benji-york/manuel/issues/34#issuecomment-2016443027
  checkPhase = ''
    ${python.interpreter} -m unittest -vv manuel.tests.test_suite
  '';

  pythonImportsCheck = [ "manuel" ];

  meta = {
    description = "Documentation builder";
    homepage = "https://pypi.org/project/manuel/";
    changelog = "https://github.com/benji-york/manuel/blob/${finalAttrs.version}/CHANGES.rst";
    license = lib.licenses.zpl20;
  };
})
