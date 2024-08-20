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
  version = "0.0.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "neomutt";
    repo = "lsp-tree-sitter";
    rev = version;
    hash = "sha256-yzScgix3BtSCBzlDoE1kMYGtVzkup/+ZK9L1C7VA3do=";
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

  meta = with lib; {
    description = "A library to create language servers";
    homepage = "https://github.com/neomutt/lsp-tree-sitter";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ doronbehar ];
  };
}
