{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, setuptools
}:

buildPythonPackage rec {
  pname = "py-tree-sitter";
  version = "0.20.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "tree-sitter";
    repo = "py-tree-sitter";
    rev = "refs/tags/v${version}";
    hash = "sha256-R97WcsHQMcuEOCg/QQ9YbGTRD30G9PRv0xAbxuoFyC4=";
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
