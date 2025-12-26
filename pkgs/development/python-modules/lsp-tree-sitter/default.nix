{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-generate,
  setuptools-scm,
  colorama,
  jinja2,
  jsonschema,
  pygls_2,
  tree-sitter,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lsp-tree-sitter";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neomutt";
    repo = "lsp-tree-sitter";
    tag = version;
    hash = "sha256-H5yb33ZsqRtqm1zlnOI0WUfcM2VDKn+qyezmFNtdLGA=";
  };

  build-system = [
    setuptools-generate
    setuptools-scm
  ];

  dependencies = [
    colorama
    jinja2
    jsonschema
    pygls_2
    tree-sitter
  ];
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "lsp_tree_sitter" ];

  meta = {
    description = "Library to create language servers";
    homepage = "https://github.com/neomutt/lsp-tree-sitter";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
