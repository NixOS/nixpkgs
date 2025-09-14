{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-generate,
  setuptools-scm,
  colorama,
  jinja2,
  jsonschema,
  pygls,
  tree-sitter,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "lsp-tree-sitter";
  version = "0.0.18";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neomutt";
    repo = "lsp-tree-sitter";
    tag = version;
    hash = "sha256-Hjl3EASaOWmLZpBxmyelSUTy7jJEIEo77IIQh5DHIbg=";
  };

  build-system = [
    setuptools-generate
    setuptools-scm
  ];

  dependencies = [
    colorama
    jinja2
    jsonschema
    pygls
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
