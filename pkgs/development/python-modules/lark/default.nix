{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  regex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "lark";
  version = "1.2.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = "refs/tags/${version}";
    hash = "sha256-02NX/2bHTYSVTDLLudJmEU2DcQNn0Ke+5ayilKLlwqA=";
  };

  nativeBuildInputs = [ setuptools ];

  # Optional import, but fixes some re known bugs & allows advanced regex features
  propagatedBuildInputs = [ regex ];

  pythonImportsCheck = [
    "lark"
    "lark.parsers"
    "lark.tools"
    "lark.grammars"
  ];

  # Js2py is needed for tests but it's unmaintained and insecure
  doCheck = false;

  meta = with lib; {
    description = "Modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = "https://lark-parser.readthedocs.io/";
    changelog = "https://github.com/lark-parser/lark/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ drewrisinger ];
  };
}
