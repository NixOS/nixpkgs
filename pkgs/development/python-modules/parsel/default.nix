{
  lib,
  buildPythonPackage,
  cssselect,
  fetchPypi,
  hatchling,
  jmespath,
  lxml,
  packaging,
  psutil,
  pytestCheckHook,
  sybil,
  w3lib,
}:

buildPythonPackage (finalAttrs: {
  pname = "parsel";
  version = "1.11.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-WSX+CH6xb8QEp+2R4x4sHiqbIw2ktk802BNYwNDifog=";
  };

  build-system = [ hatchling ];

  dependencies = [
    cssselect
    jmespath
    lxml
    packaging
    w3lib
  ];

  nativeCheckInputs = [
    psutil
    pytestCheckHook
    sybil
  ];

  pythonImportsCheck = [ "parsel" ];

  disabledTests = [
    # asserts on the exact output format of an error message
    "test_set_xpathfunc"
  ];

  meta = {
    description = "Python library to extract data from HTML and XML using XPath and CSS selectors";
    homepage = "https://github.com/scrapy/parsel";
    changelog = "https://github.com/scrapy/parsel/blob/v${finalAttrs.version}/NEWS";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
