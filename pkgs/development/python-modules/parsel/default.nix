{
  lib,
  buildPythonPackage,
  cssselect,
  fetchPypi,
  jmespath,
  lxml,
  packaging,
  psutil,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  w3lib,
}:

buildPythonPackage rec {
  pname = "parsel";
  version = "1.10.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FPF9uVWfUbQzV7nf5DzshwqO+16khXq7Yk7G/4DYoIA=";
  };

  build-system = [ setuptools ];

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
  ];

  pythonImportsCheck = [ "parsel" ];

  meta = with lib; {
    description = "Python library to extract data from HTML and XML using XPath and CSS selectors";
    homepage = "https://github.com/scrapy/parsel";
    changelog = "https://github.com/scrapy/parsel/blob/v${version}/NEWS";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
