{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  w3lib,
  parsel,
  jmespath,
  itemadapter,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "itemloaders";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scrapy";
    repo = "itemloaders";
    rev = "refs/tags/v${version}";
    hash = "sha256-DatHJnAIomVoN/GrDzM2fNnFHcXqo6zs3ucKCOCf9DU=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    w3lib
    parsel
    jmespath
    itemadapter
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "itemloaders" ];

  meta = with lib; {
    description = "Library to populate items using XPath and CSS with a convenient API";
    homepage = "https://github.com/scrapy/itemloaders";
    changelog = "https://github.com/scrapy/itemloaders/raw/v${version}/docs/release-notes.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
