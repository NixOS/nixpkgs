{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "lark-parser";
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "lark-parser";
    repo = "lark";
    rev = version;
    sha256 = "1i585q27qlwk4rpgsh621s60im1j9ynwyz5pcc8s3ffmjam28vss";
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
