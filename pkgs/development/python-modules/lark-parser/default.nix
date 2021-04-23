{ lib
, buildPythonPackage
, fetchFromGitHub
, regex
  # Test inputs
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "1v1piaxpz4780km2z5i6sr9ygi9wpn09yyh999b3f4y0dcz20pbd";
  };

  propagatedBuildInputs = [ regex ];

  checkInputs = [ pytestCheckHook ];
  disabledTestPaths = [
    "tests/test_nearley" # requires Js2Py package (not in nixpkgs)
  ];
  disabledTests = [
    "test_override_rule"  # has issue with file access paths
  ];

  meta = with lib; {
    description = "A modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = "https://github.com/lark-parser/lark";
    license = licenses.mit;
    maintainers = with maintainers; [ fridh drewrisinger ];
  };
}
