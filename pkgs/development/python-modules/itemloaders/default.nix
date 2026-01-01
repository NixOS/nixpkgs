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
  version = "1.3.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scrapy";
    repo = "itemloaders";
    tag = "v${version}";
    hash = "sha256-Hs3FodJAWZGeo+kMmcto5WW433RekwVuucaJl8TKc+0=";
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

<<<<<<< HEAD
  meta = {
    description = "Library to populate items using XPath and CSS with a convenient API";
    homepage = "https://github.com/scrapy/itemloaders";
    changelog = "https://github.com/scrapy/itemloaders/raw/v${version}/docs/release-notes.rst";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Library to populate items using XPath and CSS with a convenient API";
    homepage = "https://github.com/scrapy/itemloaders";
    changelog = "https://github.com/scrapy/itemloaders/raw/v${version}/docs/release-notes.rst";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
