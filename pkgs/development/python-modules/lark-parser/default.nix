{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "1q2dvkkfx9dvag5v5ps0ki4avh7i003gn9sj30jy1rsv1bg4y2mb";
  };

  # tests of Nearley support require js2py
  preCheck = ''
    rm -r tests/test_nearley
  '';

  meta = {
    description = "A modern parsing library for Python, implementing Earley & LALR(1) and an easy interface";
    homepage = "https://github.com/lark-parser/lark";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
