{
  buildPythonPackage,
  fetchPypi,
  lib,

  pathspec,
  setuptools,
  tree-sitter-language-pack,
}:

buildPythonPackage rec {
  pname = "grep-ast";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "grep_ast";
    hash = "sha256-YgokKkST5nITONHJpsI0rmUfh3T0kkptz5D2hl1LLuM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pathspec
    tree-sitter-language-pack
  ];

  # Tests disabled due to pending update from tree-sitter-languages to tree-sitter-language-pack
  # nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "grep_ast" ];

  meta = {
    homepage = "https://github.com/paul-gauthier/grep-ast";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ greg ];
    description = "Python implementation of the ast-grep tool";
    mainProgram = "grep-ast";
  };
}
