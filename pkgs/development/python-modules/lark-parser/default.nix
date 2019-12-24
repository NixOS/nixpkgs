{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "1k9s62ddv6pghzp1yak2ld6sk92zm4sz1xqp8zkzyh3xqdsmfa0f";
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
