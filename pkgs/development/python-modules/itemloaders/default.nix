{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  w3lib,
  parsel,
  jmespath,
  itemadapter,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "itemloaders";
  version = "1.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapy";
    repo = "itemloaders";
    tag = "v${finalAttrs.version}";
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

  meta = {
    description = "Library to populate items using XPath and CSS with a convenient API";
    homepage = "https://github.com/scrapy/itemloaders";
    changelog = "https://github.com/scrapy/itemloaders/raw/v${finalAttrs.version}/docs/release-notes.rst";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
