{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, setuptools
}:

buildPythonPackage rec {
  pname = "py-tree-sitter";
  version = "0.20.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "py-tree-sitter";
    rev = "v${version}";
    sha256 = "sha256-mdV5zGvVI1MltmOD1BtXxsKB/yigk8d56WwLlX6Uizg=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [ "tree_sitter" ];

  meta = with lib; {
    homepage = "https://github.com/tree-sitter/py-tree-sitter";
    description = "Python bindings for tree-sitter";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
    platforms = platforms.unix;
  };
}
