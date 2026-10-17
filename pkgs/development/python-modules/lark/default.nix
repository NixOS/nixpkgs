{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  regex,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "lark";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    tag = version;
    hash = "sha256-JDtLSbVjypaHqamkknHDSql1GTMf1LA4TgJXqTn4Q20=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  # Optional import, but fixes some re known bugs & allows advanced regex features
  dependencies = [ regex ];

  pythonImportsCheck = [
    "lark"
    "lark.parsers"
    "lark.tools"
    "lark.grammars"
  ];

  # Js2py is needed for tests but it's unmaintained and insecure
  doCheck = false;

  meta = {
    description = "Modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = "https://lark-parser.readthedocs.io/";
    changelog = "https://github.com/lark-parser/lark/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
