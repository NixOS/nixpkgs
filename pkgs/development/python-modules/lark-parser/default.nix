{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "1d8dbn8wwqqvvjyhai813sqkx6366d8jkjq0gkyh51692pflmwrp";
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
