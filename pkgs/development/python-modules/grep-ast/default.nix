{
  buildPythonPackage,
  fetchPypi,
  lib,

  pathspec,
  pytestCheckHook,
  setuptools,
  tree-sitter-languages,
}:

buildPythonPackage rec {
  pname = "grep-ast";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "grep_ast";
    hash = "sha256-9wl+zyNDfAS8TtcISFsNQYlMGpxKmUEVlUK4xnxJpWM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pathspec
    tree-sitter-languages
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "grep_ast" ];

  meta = {
    homepage = "https://github.com/paul-gauthier/grep-ast";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ greg ];
    description = "Python implementation of the ast-grep tool";
    mainProgram = "grep-ast";
  };
}
