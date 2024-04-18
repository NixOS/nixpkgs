{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, w3lib
, parsel
, jmespath
, itemadapter
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "itemloaders";
  version = "1.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "scrapy";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-DatHJnAIomVoN/GrDzM2fNnFHcXqo6zs3ucKCOCf9DU=";
  };

  propagatedBuildInputs = [
    w3lib
    parsel
    jmespath
    itemadapter
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Test are failing (AssertionError: Lists differ: ...)
    "test_nested_css"
    "test_nested_xpath"
  ];

  pythonImportsCheck = [
    "itemloaders"
  ];

  meta = with lib; {
    description = "Base library for scrapy's ItemLoader";
    homepage = "https://github.com/scrapy/itemloaders";
    changelog = "https://github.com/scrapy/itemloaders/raw/v${version}/docs/release-notes.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
