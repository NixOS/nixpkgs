{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  pytestCheckHook,
  lxml,
}:

buildPythonPackage (finalAttrs: {
  pname = "cssselect";
  version = "1.5.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-PL6C3XrL7pup5XI7X55HSYJpEvH7Mc1/kqq+1f3hWxU=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    lxml
  ];

  pythonImportsCheck = [ "cssselect" ];

  meta = {
    description = "CSS Selectors for Python";
    homepage = "https://cssselect.readthedocs.io/";
    changelog = "https://github.com/scrapy/cssselect/blob/v${finalAttrs.version}/CHANGES";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
