{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, regex
, pytestCheckHook
, js2py
}:

buildPythonPackage rec {
  pname = "lark";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = "refs/tags/${version}";
    sha256 = "sha256-drvF+0PSOdrha2rfpntrM8xIbeb0S7eNtfioxkdjEKw=";
  };

  # Optional import, but fixes some re known bugs & allows advanced regex features
  propagatedBuildInputs = [ regex ];

  pythonImportsCheck = [
    "lark"
    "lark.parsers"
    "lark.tools"
    "lark.grammars"
  ];

  checkInputs = [
    js2py
    pytestCheckHook
  ];

  meta = with lib; {
    description = "A modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = "https://lark-parser.readthedocs.io/";
    changelog = "https://github.com/lark-parser/lark/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fridh drewrisinger ];
  };
}
