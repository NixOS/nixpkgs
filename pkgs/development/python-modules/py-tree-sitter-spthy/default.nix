{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tree-sitter,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "py-tree-sitter-spthy";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "lmandrelli";
    repo = "py-tree-sitter-spthy";
    tag = "v${version}";
    hash = "sha256-CYDn36QUqDvuSLFSIHdKCtmkcmXJefiy35npNNnKzw4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    tree-sitter
  ];

  # There are no tests in the repository
  doCheck = false;
  pythonImportsCheck = [ "py_tree_sitter_spthy" ];

  meta = {
    description = "Tree-sitter parser for Spthy language (Tamarin Prover)";
    homepage = "https://github.com/lmandrelli/py-tree-sitter-spthy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
  };
}