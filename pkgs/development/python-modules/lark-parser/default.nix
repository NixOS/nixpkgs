{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.7.8";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "0gd5c3scpyir3h8clhwb5jsf8dkmh1vh7rx8135lkx9fxx01q0az";
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
