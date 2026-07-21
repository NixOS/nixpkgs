{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  paragraphs,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  types-lxml,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "docx2python";
  version = "3.6.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ShayHill";
    repo = "docx2python";
    tag = finalAttrs.version;
    hash = "sha256-1/v8slL7EYwXM8ybcJKIdjLBKNBxHgdF4gQHDYyJg6w=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    lxml
    paragraphs
    types-lxml
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "docx2python" ];

  meta = {
    description = "Extract docx headers, footers, (formatted) text, footnotes, endnotes, properties, and images";
    homepage = "https://github.com/ShayHill/docx2python";
    changelog = "https://github.com/ShayHill/docx2python/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
