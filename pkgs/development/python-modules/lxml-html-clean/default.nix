{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "lxml-html-clean";
  version = "0.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fedora-python";
    repo = "lxml_html_clean";
    tag = finalAttrs.version;
    hash = "sha256-CFiyQKFoJoP47/pmwQTDbRfpp1hFQTAqhBEqBEJAEtg=";
  };

  build-system = [ setuptools ];

  dependencies = [ lxml ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "lxml_html_clean" ];

  meta = {
    description = "Separate project for HTML cleaning functionalities copied from lxml.html.clean";
    homepage = "https://github.com/fedora-python/lxml_html_clean/";
    changelog = "https://github.com/fedora-python/lxml_html_clean/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
  };
})
