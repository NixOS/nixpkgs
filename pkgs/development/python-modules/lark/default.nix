{ lib
, buildPythonPackage
, fetchFromGitHub
, python
, regex
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "lark";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "sha256-Y1bDSiFnqAKTlIcd8aAgtc+I3TLnWF8hhQK2ez96TQs=";
  };

  # Optional import, but fixes some re known bugs & allows advanced regex features
  propagatedBuildInputs = [ regex ];

  pythonImportsCheck = [
    "lark"
    "lark.parsers"
    "lark.tools"
    "lark.grammars"
  ];

  checkInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_nearley/test_nearley.py"  # requires unpackaged Js2Py library
  ];

  meta = with lib; {
    description = "A modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = "https://lark-parser.readthedocs.io/";
    changelog = "https://github.com/lark-parser/lark/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fridh drewrisinger ];
  };
}
