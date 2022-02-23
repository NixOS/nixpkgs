{ lib, stdenv, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  pname = "py-tree-sitter";
  version = "unstable-2022-02-08";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "py-tree-sitter";
    rev = "9c8261d36e55d9e4a6543dc9e570bfd7911ed7bf";
    sha256 = "sha256-YDe9m85LIPNumo9mrhMMotUspq/8B3t5kt2ScMJI+hY=";
    fetchSubmodules = true;
  };

  pythonImportsCheck = [ "tree_sitter" ];

  meta = with lib; {
    homepage = "https://github.com/tree-sitter/py-tree-sitter";
    description = "Python bindings for tree-sitter";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
