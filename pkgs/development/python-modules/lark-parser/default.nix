{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "1rfybmr0rlljhc0dpd9npbw8x7r6dvnn2wvclz93rmgkzhmd3zah";
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
