{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "17h7s0yc8jyjmlcwsaw93ijl982ws3p8nxif2dc3rv01dqhf0xx1";
  };

  # tests of Nearley support require js2py
  preCheck = ''
    rm -r tests/test_nearley
  '';

  meta = {
    description = "A modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = https://github.com/lark-parser/lark;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
